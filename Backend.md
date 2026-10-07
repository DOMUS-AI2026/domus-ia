# DOMUS AI — Backend

API que alimenta o site e (futuramente) o app mobile do DOMUS AI, seguindo a
arquitetura da seção 29 do briefing: **FastAPI + MySQL (estado estrutural) +
MongoDB (séries temporais/eventos)**.

Os dados dos 9 ambientes e os 3 nomes de sensores/dispositivos são exatamente
os mesmos usados no protótipo front-end (`domus-app.html`), então dá pra
plugar um no outro sem remapear nada.

## 1. Setup

```bash
python -m venv .venv && source .venv/bin/activate   # ou .venv\Scripts\activate no Windows
pip install -r requirements.txt

cp .env.example .env          # ajuste usuário/senha do MySQL e a URL do Mongo
mysql -u root -p < schema.sql # cria o banco domus_ai e as tabelas
python -m app.seed            # popula com os 9 ambientes (mesmos dados do protótipo)
uvicorn app.main:app --reload --port 8000
```

Depois abra `http://localhost:8000/docs` — o Swagger já vem pronto com todos os endpoints.

## 2. Estrutura

```
app/
  main.py              # cria o FastAPI app e registra os routers
  config.py            # lê .env (MYSQL_URL, MONGO_URL...)
  database.py          # engine/sessão SQLAlchemy (MySQL)
  mongo.py             # cliente motor (MongoDB) + coleções
  seed.py              # popula o banco com a planta de 120 m²
  models/sql_models.py # ORM: Home, Room, Sensor, Device, RoomStatus, Alert, Automation, Command, DomusScore
  schemas/pydantic_schemas.py  # contratos de request/response da API
  services/
    score_engine.py       # cálculo do DOMUS SCORE (mesma fórmula do front-end)
    automation_engine.py  # regras condição→ação (mesma lógica do front-end)
  routers/
    rooms.py        # GET estado da casa -> alimenta a planta 2D/3D
    devices.py       # POST comando (ligar/desligar/abrir/fechar)
    alerts.py         # GET/POST Alert Center
    score.py           # GET DOMUS SCORE
    automations.py     # GET/POST regras de automação
    simulate.py         # POST cenários do Simulador (ExpoTech)
```

## 3. Por que MySQL **e** MongoDB

- **MySQL** guarda o que é estrutural e relacional: quais ambientes existem, quais
  sensores/dispositivos cada um tem, o estado *atual* de cada um, alertas e o
  histórico de comandos. É o que a planta 2D/3D consulta a cada carregamento.
- **MongoDB** guarda o que é série temporal / alto volume: cada leitura bruta de
  sensor, snapshots de telemetria, eventos de automação e os disparos do
  simulador. É onde entraria futuramente a camada de Data Science (seção 31).

## 4. Como o front-end (protótipo `domus-app.html`) se conecta aqui

Hoje o protótipo guarda o estado num objeto `rooms{}` em JavaScript, só na
memória do navegador. Para plugar nesta API:

1. `GET /homes/{home_id}/rooms` no carregamento da página → preenche `rooms{}`.
2. Trocar `toggleDevice()` / `applyEvent()` por chamadas a
   `POST /homes/{home_id}/rooms/{slug}/devices/{key}/command` e
   `POST /homes/{home_id}/simulate`.
3. Trocar `computeScore()` local por `GET /homes/{home_id}/score`.
4. Um `setInterval` chamando `GET /rooms` a cada poucos segundos (ou, no
   próximo passo, WebSocket) mantém 2D, 3D e o app mobile sempre iguais —
   exatamente o "SITE ↓ API ↓ APP" da seção 28.

## 5. Próximos passos sugeridos

- WebSocket (`/ws`) para os clientes serem avisados em tempo real, sem polling.
- Autenticação (JWT) nas rotas, hoje abertas para facilitar o desenvolvimento.
- Job assíncrono (Celery/APScheduler) para gerar leituras simuladas realistas em
  segundo plano (seção 31 — padrões por horário do dia).
