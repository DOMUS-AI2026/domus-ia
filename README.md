# DOMUS AI

Plataforma de inteligência residencial — gêmeo digital da casa (planta 2D/3D,
sensores, alertas, DOMUS Score, automações) com 3 planos (START / SMART / AI),
backend em FastAPI + MySQL + MongoDB, e scaffolds de integração e app mobile.

> "O sensor percebe. O DOMUS pensa. O atuador executa."

## Estrutura do repositório

```
domus-ai/
├── frontend/
│   ├── domus-app.html        ← o app completo (abra direto no navegador, sem build)
│   └── legacy/                 primeiros protótipos (planta 2D e 3D isoladas)
├── backend/                   FastAPI + MySQL + MongoDB + WebSocket (ver backend/README.md)
├── integration/                guia + cliente JS para o front-end falar com a API
├── mobile-ios-scan/            scaffold Swift (RoomPlan) p/ escanear um ambiente com LiDAR
├── site-seo/                   demo.html pronto p/ Netlify, sitemap.xml, robots.txt
└── presentation/               apresentação (slides) em HTML sobre o projeto
```

## O que já funciona (`frontend/domus-app.html`)

Arquivo único, HTML + JS puro + Three.js por CDN — sem build, sem `npm install`.
Abra localmente ou publique em qualquer hospedagem estática.

- Seletor de plano **DOMUS START / SMART / AI**, cada um com sua planta, área e
  quantidade de sensores (iguais aos planos da landing)
- Planta **2D e 3D** da mesma casa, alternáveis, com um único estado compartilhado
- Sensores e dispositivos individuais (presença, temperatura, água, vazamento,
  luz, ar-condicionado com modo frio/quente/ambiente, válvula, porta, janela,
  máquina de lavar), com comando e agendamento por horário
- **DOMUS Score**, **Alert Center**, **DOMUS Water/Energy/Security**, e
  **DOMUS Automation** (regras reais que resolvem sozinhas, com atraso e log)
- Cor do ambiente e Score reagem tanto a simulações quanto a comandos manuais

## O que ainda depende de infraestrutura própria

- **`backend/`** — não foi testado contra um MySQL/MongoDB reais ainda (ver
  "problemas conhecidos" no `backend/README.md`). Pronto como ponto de partida,
  não como produção.
- **`mobile-ios-scan/`** — só funciona dentro de um app iOS nativo de verdade,
  com aparelho LiDAR. É scaffold, não um app publicável por si só.
- **`integration/`** — conecta o `domus-app.html` ao backend; só funciona
  quando os dois rodam no seu próprio domínio (não dentro do Claude).

## Como colocar no ar hoje (caminho mais simples)

1. Suba `frontend/domus-app.html` (ou `site-seo/demo.html`, já com SEO) no Netlify.
2. Linke um botão da sua landing atual para esse arquivo.
3. Backend, integração e app mobile entram depois, como evolução.

## Subindo este repositório no GitHub

Dentro desta pasta (depois de extrair o zip):

```bash
git init
git add .
git commit -m "DOMUS AI — versão inicial completa"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/domus-ai.git
git push -u origin main
```

Se o repositório no GitHub já existir com algo dentro (ex: um README padrão),
troque o push por:

```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

## Histórico do projeto

Este repositório foi construído em etapas, nesta ordem: planta 2D interativa →
planta 3D (Three.js) → unificação num único app com estado compartilhado →
sensores e dispositivos individuais → DOMUS Score e Alert Center → Water /
Energy / Security → Automation → backend (FastAPI/MySQL/MongoDB) → WebSocket
tempo real → guia de integração → scanner de ambiente (RoomPlan) → múltiplos
planos (START/SMART/AI). Cada pasta reflete o estado final dessa etapa.
