/* =========================================================
   DOMUS AI · catálogo de produtos — v4 Premium
   Para adicionar ou editar um produto, mexa só na lista PRODUTOS.
   planos: quais planos incluem o produto (Start, Smart, AI)
   ========================================================= */

const ICONES = {
  hub: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="31" y="18" width="38" height="66" rx="19"/><ellipse cx="50" cy="26" rx="12" ry="3.5" stroke-opacity=".9"/><circle cx="50" cy="26" r="1.6" fill="currentColor"/><g stroke-opacity=".45"><path d="M38 44h24M38 52h24M38 60h24M38 68h24"/></g><path d="M22 40c-4 6-4 14 0 20M78 40c4 6 4 14 0 20" stroke-opacity=".6"/></svg>`,
  agua: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><ellipse cx="50" cy="70" rx="28" ry="9"/><path d="M22 70v6c0 5 12.5 9 28 9s28-4 28-9v-6"/><path d="M50 18s13 14 13 24a13 13 0 0 1-26 0c0-10 13-24 13-24Z"/><circle cx="50" cy="70" r="2" fill="currentColor"/></svg>`,
  fluxo: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M8 58h22M70 58h22M8 70h22M70 70h22"/><rect x="30" y="48" width="40" height="32" rx="6"/><rect x="36" y="22" width="28" height="26" rx="5"/><path d="M42 36l5-6 4 4 6-7" /><path d="M14 52v24M86 52v24" stroke-opacity=".5"/></svg>`,
  valvula: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M6 60h26M68 60h26M6 74h26M68 74h26"/><rect x="32" y="52" width="36" height="30" rx="6"/><path d="M50 52V36"/><circle cx="50" cy="28" r="10"/><path d="M50 18v20M40 28h20" stroke-opacity=".6"/><circle cx="62" cy="58" r="2" fill="currentColor"/></svg>`,
  energia: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="28" y="16" width="44" height="68" rx="6"/><rect x="36" y="24" width="28" height="16" rx="3"/><path d="M53 48 44 62h9l-3 12 10-16h-9l2-10Z"/><path d="M40 84v6M60 84v6" stroke-opacity=".6"/></svg>`,
  tomada: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="22" y="22" width="56" height="56" rx="14"/><circle cx="50" cy="50" r="16"/><circle cx="44" cy="50" r="2.4" fill="currentColor"/><circle cx="56" cy="50" r="2.4" fill="currentColor"/><circle cx="68" cy="30" r="2" fill="currentColor" stroke="none"/></svg>`,
  luz: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="20" y="30" width="34" height="50" rx="7"/><rect x="29" y="40" width="16" height="30" rx="4"/><path d="M29 52h16" stroke-opacity=".6"/><path d="M72 30a10 10 0 0 0-6 18v6h12v-6a10 10 0 0 0-6-18Z"/><path d="M68 60h8M72 14v6M86 22l-4 4M58 22l4 4M90 36h-5" stroke-opacity=".7"/></svg>`,
  presenca: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M28 30h44"/><path d="M34 30a16 16 0 0 0 32 0"/><circle cx="50" cy="36" r="4"/><path d="M36 62c8 6 20 6 28 0M28 72c12 9 32 9 44 0M20 82c16 12 44 12 60 0" stroke-opacity=".6"/></svg>`,
  clima: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="14" y="22" width="72" height="28" rx="8"/><path d="M22 42h56" stroke-opacity=".6"/><circle cx="74" cy="30" r="2" fill="currentColor"/><path d="M34 60c-3 5-3 11 0 16M50 60c-3 5-3 11 0 16M66 60c-3 5-3 11 0 16" stroke-opacity=".7"/></svg>`,
  guard: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M22 86V16h40v70"/><path d="M14 86h56"/><circle cx="54" cy="52" r="2" fill="currentColor"/><rect x="66" y="34" width="10" height="22" rx="3"/><rect x="66" y="60" width="10" height="12" rx="3" stroke-opacity=".7"/><path d="M82 40c3 3 3 9 0 12" stroke-opacity=".6"/></svg>`,
  camera: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="18" y="32" width="50" height="36" rx="8"/><circle cx="43" cy="50" r="12"/><circle cx="43" cy="50" r="6"/><circle cx="43" cy="50" r="2" fill="currentColor"/><path d="M68 42l14-8v32l-14-8"/><circle cx="24" cy="38" r="2" fill="currentColor"/></svg>`,
  fechadura: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="28" y="42" width="44" height="44" rx="8"/><path d="M38 42V32a12 12 0 0 1 24 0v10"/><circle cx="50" cy="64" r="6"/><path d="M50 70v8"/></svg>`,
  gas: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><rect x="22" y="30" width="56" height="48" rx="10"/><path d="M38 46c0-5 4-8 8-6s4 8 0 10-8 5-8 10 4 8 8 8 8-3 8-8"/><path d="M38 30V20M62 30V20"/></svg>`,
  sirene: `<svg viewBox="0 0 100 100" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M50 22 28 58h44L50 22Z"/><circle cx="50" cy="70" r="8"/><circle cx="50" cy="70" r="3" fill="currentColor"/><path d="M20 44c-6 8-6 20 0 28M80 44c6 8 6 20 0 28" stroke-opacity=".6"/></svg>`,
};

const PRODUTOS = [
  // ── CENTRAL ──────────────────────────────────────────────────
  {
    id: "hub", nome: "DOMUS Hub", cat: "Central", badge: "Novo",
    resumo: "O cérebro da casa: reúne os dados de todos os sensores e fala com você por voz.",
    faz: "Recebe as leituras de todos os sensores, roda as análises do DOMUS AI e envia os comandos para os atuadores. Compatível com Wi-Fi, Zigbee e Z-Wave. Também responde por voz: “DOMUS, como está o consumo hoje?”.",
    mede: "Conecta até 128 dispositivos DOMUS e de terceiros", onde: "Sala ou outro ponto central, ligado ao Wi-Fi",
    preco: "R$ 690", parcela: "11x R$ 62,73",
    specs: [["Conectividade", "Wi-Fi 6, Zigbee 3.0, Z-Wave"], ["Alcance", "Até 100 m (campo aberto)"], ["Processador", "Quad-core 1.8 GHz"], ["Armazenamento", "8 GB (dados locais)"], ["Fonte", "Bivolt 100–240 V"], ["Dimensões", "Ø 90 × 120 mm"]],
    planos: ["Start", "Smart", "AI"]
  },

  // ── ÁGUA ─────────────────────────────────────────────────────
  {
    id: "agua", nome: "DOMUS Sense Água", cat: "Água",
    resumo: "Detecta água no piso antes de virar prejuízo — avisa em segundos.",
    faz: "Fica no chão, perto de registros, máquinas de lavar e pias. Ao sentir qualquer umidade, avisa o DOMUS instantaneamente e você recebe a notificação no app.",
    mede: "Presença de água e umidade no piso", onde: "Banheiro, cozinha, área de serviço",
    preco: "R$ 189", parcela: "6x R$ 31,50",
    specs: [["Sensor", "Eletrodos de detecção de umidade"], ["Bateria", "CR2032 (até 3 anos)"], ["Protocolo", "Zigbee 3.0"], ["Alerta", "<3 segundos após contato"], ["Proteção", "IP67 — à prova d'água"], ["Dimensões", "Ø 72 × 18 mm"]],
    planos: ["Smart", "AI"]
  },

  {
    id: "fluxo", nome: "DOMUS Fluxo", cat: "Água",
    resumo: "Mede cada litro que passa pela casa em tempo real.",
    faz: "Instalado na entrada de água, acompanha quantos litros a casa usa por hora e ajuda o DOMUS a perceber consumo fora do padrão — inclusive um cano pingando há dias.",
    mede: "Vazão (L/h) e consumo diário, semanal, mensal", onde: "Entrada de água da residência",
    preco: "R$ 349", parcela: "7x R$ 49,86",
    specs: [["Faixa de medição", "0,5 – 60 L/min"], ["Precisão", "±1,5%"], ["Pressão máx.", "10 bar"], ["Conexão", "3/4″ BSP"], ["Protocolo", "Zigbee 3.0"], ["Proteção", "IP65"]],
    planos: ["Smart", "AI"]
  },

  {
    id: "valvula", nome: "DOMUS Válvula", cat: "Água",
    resumo: "Fecha o registro pelo app — ou sozinha, quando detecta vazamento.",
    faz: "Atuador instalado no registro geral. Recebe o comando do DOMUS e fecha a água automaticamente quando há vazamento confirmado, evitando danos maiores.",
    mede: "Estado do registro (aberto, fechado, parcial)", onde: "Registro geral ou de um cômodo",
    preco: "R$ 429", parcela: "9x R$ 47,67",
    specs: [["Torque", "5 N·m"], ["Tempo de ação", "<8 segundos"], ["Compatibilidade", "Ø 3/4″ e 1″"], ["Tensão", "5 V (USB-C, cabo incluso)"], ["Protocolo", "Zigbee 3.0"], ["Ciclos", ">50.000 operações"]],
    planos: ["AI"]
  },

  // ── ENERGIA ──────────────────────────────────────────────────
  {
    id: "energia", nome: "DOMUS Energia", cat: "Energia",
    resumo: "Mostra para onde vai cada watt da casa, em tempo real.",
    faz: "Instalado no quadro de luz, mede o consumo de cada circuito em tempo real, identifica os horários de pico e calcula a previsão da conta do mês.",
    mede: "Consumo (kW), histórico (kWh), custo estimado", onde: "Quadro de distribuição elétrico",
    preco: "R$ 519", parcela: "9x R$ 57,67",
    specs: [["Circuitos monitorados", "Até 12 (expansível)"], ["Precisão", "±0,5% (Classe B)"], ["Tensão", "110 / 220 V"], ["Atualização", "A cada 1 segundo"], ["Protocolo", "Wi-Fi + Zigbee"], ["Dimensões", "DIN 6 módulos"]],
    planos: ["Smart", "AI"]
  },

  {
    id: "tomada", nome: "DOMUS Tomada", cat: "Energia",
    resumo: "Liga, desliga e mede qualquer aparelho — diretamente da tomada.",
    faz: "Tomada inteligente que corta a energia de um equipamento pelo app e mede quanto ele gasta. Identifica standby e avisa quando um aparelho fica ligado desnecessariamente.",
    mede: "Consumo do aparelho (W e kWh) e tempo de uso", onde: "Qualquer tomada da casa (tipo N ABNT)",
    preco: "R$ 159", parcela: "5x R$ 31,80",
    specs: [["Corrente máx.", "16 A"], ["Potência máx.", "3.500 W"], ["Medição", "0,1 W de resolução"], ["Tensão", "110 / 220 V (bivolt)"], ["Protocolo", "Zigbee 3.0"], ["Proteção", "Contra surtos SPD"]],
    planos: ["AI"]
  },

  // ── CONFORTO ─────────────────────────────────────────────────
  {
    id: "luz", nome: "DOMUS Luz", cat: "Conforto",
    resumo: "Iluminação que apaga sozinha quando ninguém está no cômodo.",
    faz: "Relé que fica atrás do interruptor existente. Permite ligar e desligar as luzes pelo app, por voz ou por automação baseada em presença — sem trocar o interruptor.",
    mede: "Estado e tempo de uso de cada ponto de luz", onde: "Interruptores de qualquer cômodo",
    preco: "R$ 139", parcela: "5x R$ 27,80",
    specs: [["Carga máx.", "1.000 W (resistiva) / 400 W (LED)"], ["Tipo", "Relé SPST com dimmer opcional"], ["Tensão", "110 / 220 V"], ["Protocolo", "Zigbee 3.0"], ["Profundidade", "32 mm (caixa 4×4)"], ["Temperatura", "–10 °C a +45 °C"]],
    planos: ["Start", "Smart", "AI"]
  },

  {
    id: "presenca", nome: "DOMUS Presença", cat: "Conforto", badge: "Mais vendido",
    resumo: "Sabe se o cômodo está ocupado e mede a temperatura ambiente.",
    faz: "Sensor de presença PIR combinado com termômetro. Percebe movimento e presença no ambiente. É ele que avisa quando o ar ou a luz estão ligados num cômodo vazio há minutos.",
    mede: "Ocupação, temperatura (±0,3 °C) e luminosidade", onde: "Teto ou parede de cada cômodo",
    preco: "R$ 219", parcela: "7x R$ 31,29",
    specs: [["Tecnologia", "PIR dual + termistor NTC"], ["Ângulo de detecção", "120°"], ["Alcance", "Até 7 m"], ["Temperatura", "–10 °C a +55 °C"], ["Bateria", "2× AAA (até 2 anos)"], ["Protocolo", "Zigbee 3.0"]],
    planos: ["Start", "Smart", "AI"]
  },

  {
    id: "clima", nome: "DOMUS Clima", cat: "Conforto",
    resumo: "Controla o ar-condicionado que você já tem — sem trocá-lo.",
    faz: "Envia comandos ao ar-condicionado por infravermelho: liga, desliga e ajusta a temperatura pelo DOMUS. Compatível com mais de 6.000 modelos de ar-condicionado.",
    mede: "Estado e tempo de uso do ar-condicionado", onde: "Mesmo ambiente do ar-condicionado",
    preco: "R$ 249", parcela: "7x R$ 35,57",
    specs: [["Emissão IR", "360° (omnidirecional)"], ["Alcance IR", "Até 10 m"], ["Compatibilidade", "6.000+ modelos (BD incluído)"], ["Atualização", "Auto (via nuvem)"], ["Alimentação", "5 V USB-C"], ["Protocolo", "Wi-Fi + IR"]],
    planos: ["AI"]
  },

  // ── SEGURANÇA ────────────────────────────────────────────────
  {
    id: "guard", nome: "DOMUS Guard", cat: "Segurança",
    resumo: "Avisa quando portas e janelas abrem — especialmente fora do horário esperado.",
    faz: "Sensor de abertura magnético que registra cada evento. O DOMUS aprende os horários normais e avisa quando algo abre em um horário suspeito.",
    mede: "Abertura, fechamento e tempo de porta/janela aberta", onde: "Portas de entrada e janelas",
    preco: "R$ 119", parcela: "4x R$ 29,75",
    specs: [["Tecnologia", "Reed switch magnético"], ["Distância de ativação", "<15 mm"], ["Bateria", "CR2032 (até 4 anos)"], ["Temperatura", "–20 °C a +60 °C"], ["Protocolo", "Zigbee 3.0"], ["Dimensões", "38 × 14 × 11 mm"]],
    planos: ["AI"]
  },

  {
    id: "camera", nome: "DOMUS Vision", cat: "Segurança", badge: "Novo",
    resumo: "Câmera 4K com visão noturna e detecção de pessoa por IA.",
    faz: "Câmera interna ou externa com resolução 4K e detecção de pessoa por inteligência artificial. Grava somente quando algo relevante acontece. Integrada ao DOMUS AI, reconhece quando um cômodo está ocupado.",
    mede: "Vídeo 4K, detecção de pessoa, áudio bidirecional", onde: "Entrada, garagem, sala, área externa",
    preco: "R$ 549", parcela: "9x R$ 61,00",
    specs: [["Resolução", "4K (3840×2160 p)"], ["Visão noturna", "Colorida até 10 m"], ["Campo de visão", "130° diagonal"], ["Armazenamento", "MicroSD 128 GB incluso + nuvem"], ["Proteção", "IP65 (versão externa)"], ["Protocolo", "Wi-Fi 6"]],
    planos: ["AI"]
  },

  {
    id: "fechadura", nome: "DOMUS Lock", cat: "Segurança",
    resumo: "Fechadura inteligente com biometria, PIN e app — sem chave.",
    faz: "Substitui a fechadura da porta principal. Permite entrada por digital, PIN de 6 dígitos ou app. O DOMUS sabe quando alguém chegou em casa e pode desarmar o alarme automaticamente.",
    mede: "Eventos de entrada/saída, bateria e status de trava", onde: "Porta principal ou secundária",
    preco: "R$ 899", parcela: "12x R$ 74,92",
    specs: [["Autenticação", "Biometria + PIN + App + cartão NFC"], ["Biometria", "500 digitais armazenadas"], ["Bateria", "4× AA (até 12 meses)"], ["Alerta de bateria", "20%, 10% e 5%"], ["Proteção", "IP44"], ["Protocolo", "Zigbee 3.0 + BLE"]],
    planos: ["AI"]
  },

  {
    id: "gas", nome: "DOMUS Sense Gás", cat: "Segurança",
    resumo: "Detecta vazamento de gás GLP e GN antes que chegue ao nariz.",
    faz: "Sensor eletroquímico que detecta concentrações mínimas de gás. Quando ativa, avisa no app e pode acionar a válvula de gás para cortar o fornecimento automaticamente.",
    mede: "Concentração de GLP (butano/propano) e GN (metano)", onde: "Cozinha, próximo ao fogão e ao botijão",
    preco: "R$ 279", parcela: "7x R$ 39,86",
    specs: [["Tecnologia", "Sensor eletroquímico dual"], ["Limiar de alerta", "10% LEL (norma ABNT)"], ["Tempo de resposta", "<30 segundos"], ["Alimentação", "5 V USB-C (cabo incluso)"], ["Certificação", "Inmetro + ANATEL"], ["Protocolo", "Zigbee 3.0 + sirene embutida"]],
    planos: ["AI"]
  },

  {
    id: "sirene", nome: "DOMUS Siren", cat: "Segurança",
    resumo: "Sirene com flash estroboscópico para alertas que não passam despercebidos.",
    faz: "Sirene de 110 dB com flash LED que é ativada pelo DOMUS quando há intrusão, vazamento grave ou situação de emergência. Pode ser silenciada pelo app.",
    mede: "Estado (ativa / silenciosa), duração do alerta", onde: "Área externa ou corredor interno",
    preco: "R$ 199", parcela: "6x R$ 33,17",
    specs: [["Volume", "110 dB a 1 m"], ["Flash", "LED estroboscópico multicolor"], ["Alimentação", "Bivolt 100–240 V"], ["Backup", "Bateria interna 4h"], ["Proteção", "IP44"], ["Protocolo", "Zigbee 3.0"]],
    planos: ["AI"]
  },
];

/* ──────── mapeamento de fotos por produto ──────── */
const FOTOS = {
  hub: "img/produto-hub.png",
  presenca: "img/produto-presenca.png",
  energia: "img/produto-energia.png",
  agua: "img/produto-agua.png",
  camera: "img/produto-camera.png",
  fechadura: "img/produto-fechadura.png",
};

/* ──────── helpers ──────── */
const badgeHTML = p => p.badge
  ? `<span class="prod-badge">${p.badge}</span>`
  : "";

const artHTML = p => FOTOS[p.id]
  ? `<img src="${FOTOS[p.id]}" alt="${p.nome}" loading="lazy" class="prod-foto">`
  : `<span class="art-svg" aria-hidden="true">${ICONES[p.id]}</span>`;

const card = p => `
  <button class="product reveal" type="button" data-id="${p.id}" data-cat="${p.cat}">
    <span class="art" aria-hidden="true">${artHTML(p)}${badgeHTML(p)}</span>
    <span class="info">
      <span class="cat">${p.cat}</span>
      <h3>${p.nome}</h3>
      <p>${p.resumo}</p>
      <span class="prod-preco">${p.preco} <small>${p.parcela}</small></span>
      <span class="more">Ver detalhes</span>
    </span>
  </button>`;

const specsHTML = p => p.specs
  ? `<dl class="prod-specs">${p.specs.map(([k, v]) => `<div><dt>${k}</dt><dd>${v}</dd></div>`).join("")}</dl>`
  : "";

(function () {
  /* renderiza os grids */
  document.querySelectorAll("[data-produtos]").forEach(box => {
    const ids = (box.dataset.produtos || "").split(",").filter(Boolean);
    const lista = ids.length ? ids.map(id => PRODUTOS.find(p => p.id === id)).filter(Boolean) : PRODUTOS;
    box.innerHTML = lista.map(card).join("");
  });

  /* filtros por categoria */
  const filtros = document.getElementById("filtros");
  if (filtros) {
    const cats = ["Todos", ...new Set(PRODUTOS.map(p => p.cat))];
    filtros.innerHTML = cats.map((c, i) => `<button type="button" aria-pressed="${i === 0}">${c}</button>`).join("");
    filtros.addEventListener("click", e => {
      const b = e.target.closest("button"); if (!b) return;
      filtros.querySelectorAll("button").forEach(x => x.setAttribute("aria-pressed", String(x === b)));
      document.querySelectorAll(".product").forEach(el => {
        el.hidden = b.textContent !== "Todos" && el.dataset.cat !== b.textContent;
        el.classList.add("in");
      });
    });
  }

  /* modal de detalhes — versão premium */
  const dlg = document.createElement("dialog");
  dlg.className = "modal";
  document.body.appendChild(dlg);

  document.addEventListener("click", e => {
    const b = e.target.closest(".product"); if (!b) return;
    const p = PRODUTOS.find(x => x.id === b.dataset.id);
    dlg.innerHTML = `
      <div class="m-grid">
        <div class="art modal-art-wrap">
          ${FOTOS[p.id]
        ? `<img src="${FOTOS[p.id]}" alt="${p.nome}" class="modal-foto">`
        : `<span class="art-svg-lg" aria-hidden="true">${ICONES[p.id]}</span>`}
          ${p.badge ? `<span class="prod-badge">${p.badge}</span>` : ""}
        </div>
        <div class="body">
          <span class="eyebrow">${p.cat}</span>
          <h3>${p.nome}</h3>
          <p class="lede" style="font-size:.98rem">${p.faz}</p>
          <div class="modal-preco">
            <b>${p.preco}</b>
            <small>${p.parcela} sem juros</small>
          </div>
          ${specsHTML(p)}
          <dl class="modal-meta">
            <div><dt>O que percebe ou controla</dt><dd>${p.mede}</dd></div>
            <div><dt>Onde fica</dt><dd>${p.onde}</dd></div>
            <div><dt>Vem nos planos</dt><dd class="plans-tag">${p.planos.map(x => `<span>DOMUS ${x.toUpperCase()}</span>`).join("")}</dd></div>
          </dl>
          <a class="btn primary sm" href="planos.html" style="justify-self:start">Ver planos</a>
        </div>
      </div>
      <button class="x" type="button" aria-label="Fechar">✕</button>`;
    dlg.querySelector(".x").onclick = () => dlg.close();
    dlg.showModal();
  });

  dlg.addEventListener("click", e => { if (e.target === dlg) dlg.close(); });
})();
