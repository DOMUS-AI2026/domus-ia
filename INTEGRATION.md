# Integrando o protótipo front-end (`domus-app.html`) com a API

Hoje o `domus-app.html` guarda tudo no objeto `rooms{}` em memória, no navegador.
Este guia mostra, função por função, o que trocar para ele passar a falar com o
backend real (`domus-backend`). O resultado visual não muda nada — só a origem
dos dados.

## 0. Pré-requisito

Backend rodando localmente (ver README do `domus-backend.zip`):

```bash
uvicorn app.main:app --reload --port 8000
```

E `python -m app.seed` já executado (isso define `home_id = 1`, usado nos
exemplos abaixo).

> **Importante:** isso só funciona rodando o HTML localmente (ex: abrindo o
> arquivo no navegador ou com `python -m http.server`) ou publicado no seu
> próprio domínio. Uma página publicada como artefato do Claude não consegue
> falar com `localhost:8000` — a política de segurança do ambiente do Claude só
> permite chamadas à API da própria Anthropic, não a servidores arbitrários.

## 1. Incluir o cliente da API

No `<head>` do `domus-app.html`, antes do `<script>` principal:

```html
<script>window.DOMUS_API_BASE = "http://localhost:8000";</script>
<script src="domus-api-client.js"></script>
```

## 2. Trocar a inicialização do estado

**Antes** (dados fixos no topo do script):
```js
const rooms = { sala: {...}, cozinha: {...}, ... };
const defaults = JSON.parse(JSON.stringify(rooms));
```

**Depois:**
```js
let rooms = {};       // preenchido no bootstrap()
const HOME_ID = 1;

async function bootstrap(){
  rooms = DomusAPI.mapRoomsToLocalState(await DomusAPI.fetchRooms(HOME_ID));
  buildPlant2D();      // como já existiam no protótipo
  buildScene3D();
  refreshAll();

  // tempo real: qualquer mudança (site, futuro app mobile, ou automação
  // disparada no servidor) chega aqui na hora, sem precisar dar F5.
  DomusAPI.connectRealtime(HOME_ID, async (msg) => {
    if (msg.type === "rooms_changed") await syncFromServer();
    if (msg.type === "automations_changed") await renderAutomation();
  });
}
async function syncFromServer(){
  rooms = DomusAPI.mapRoomsToLocalState(await DomusAPI.fetchRooms(HOME_ID));
  refreshAll();
}
bootstrap(); // troca o antigo buildPlant2D(); buildScene3D(); refreshAll(); do final do arquivo
```

> Se a conexão WebSocket cair (Wi-Fi da ExpoTech instável, por exemplo),
> `connectRealtime` reconecta sozinho a cada 2s — não precisa de nenhum
> tratamento extra no front-end.

## 3. Comando de dispositivo (luz, válvula, porta, janela, máquina)

**Antes:**
```js
function toggleDevice(room, key){
  const meta = SENSOR_META[key];
  const cur = rooms[room].sensors[key];
  rooms[room].sensors[key] = (cur===meta.onVal) ? meta.offVal : meta.onVal;
  refreshAll(room);
}
```

**Depois:**
```js
async function toggleDevice(room, key){
  await DomusAPI.sendCommand(HOME_ID, room, key, "toggle");
  await syncFromServer();   // servidor já rodou as automações relacionadas
}
```

## 4. Simulador (botões "▶ Simular ...")

O `applyEvent(id)` local vira uma chamada ao endpoint `/simulate`. Mapeie a
chave do evento para o nome de cenário do backend
(`app/routers/simulate.py → SCENARIOS`):

| botão do protótipo          | `scenario` na API   |
|------------------------------|----------------------|
| Banheiro: Possível vazamento | `vazamento`          |
| Cozinha: Consumo elevado     | `alto_consumo`       |
| Sala: Ar sem presença        | `ar_sem_presenca`     |
| Quarto 1: Luz sem presença   | `luz_sem_presenca`    |
| Escritório: normal           | `consumo_normal`      |

```js
const SCENARIO_MAP = {
  banheiro: "vazamento", cozinha: "alto_consumo", sala: "ar_sem_presenca",
  quarto1: "luz_sem_presenca", escritorio: "consumo_normal",
};
async function applyEvent(roomId){
  await DomusAPI.simulate(HOME_ID, SCENARIO_MAP[roomId], roomId);
  await syncFromServer();
}
async function restaurarCasa(){
  await DomusAPI.simulate(HOME_ID, "restaurar");
  await syncFromServer();
}
```

> Os cenários `suite`, `banhosuite` e `lavanderia` do protótipo ainda não têm
> uma entrada equivalente no backend — adicione em `SCENARIOS` no
> `simulate.py` seguindo o mesmo padrão dos outros.

## 5. Alert Center

**Antes:** `computeAlerts()` calculava tudo a partir de `rooms{}` local.

**Depois:** busca direto da API (que já é a fonte da verdade):

```js
async function renderAlerts(){
  const alerts = await DomusAPI.fetchAlerts(HOME_ID);
  // alerts[i] = {id, room_id, status, message, created_at}
  // troque o `a.id` do map de sala/cozinha/etc por `a.room_id` e resolva:
  // <button onclick="resolveAlertRemote(${a.id})">Resolver</button>
}
async function resolveAlertRemote(alertId){
  await DomusAPI.resolveAlert(HOME_ID, alertId);
  await syncFromServer();
}
```
(Você vai precisar de um `roomIdToSlug` — monte a partir do retorno de `fetchRooms`.)

## 6. DOMUS Score

**Antes:** `computeScore()` local.
**Depois:**
```js
async function renderScore(){
  const s = await DomusAPI.fetchScore(HOME_ID);
  // s = {overall, energia, agua, eficiencia, seguranca, sustentabilidade, comportamento}
}
```

## 7. Automação (switches ligar/desligar regra)

```js
async function toggleRule(ruleKey){
  await DomusAPI.toggleAutomation(HOME_ID, ruleKey);
  renderAutomation(); // re-busca a lista via DomusAPI.fetchAutomations(HOME_ID)
}
```

## 8. O que **não** muda

Todo o código de desenho (`buildPlant2D`, `render2DRoom`, `buildScene3D`,
`refresh3DRoom`, raycasting, câmera, CSS) continua exatamente igual — ele só
lê o objeto `rooms{}`, e não importa mais se esse objeto veio de uma constante
local ou da API.

## 9. Sobre o WebSocket

O backend já expõe `/ws/homes/{home_id}` e avisa `{"type":"rooms_changed"}`
sempre que um comando, uma simulação ou uma automação mudam qualquer coisa —
inclusive mudanças causadas pelo **próprio motor de automação** rodando no
servidor (ex: fechar a válvula sozinho 1,8s depois do vazamento), que agora
aparecem no navegador sem precisar de nenhum polling. `DomusAPI.connectRealtime`
(passo 2 acima) já cuida da conexão e da reconexão automática.

Próximo passo real, quando o app mobile existir: os dois clientes (site e
app) se conectam nesse mesmo WebSocket e ficam sincronizados entre si, não só
com o servidor — exatamente o fluxo da seção 28 do briefing.
