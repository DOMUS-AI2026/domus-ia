/* =========================================================
   DOMUS AI · cabeçalho, menu e rodapé de todas as páginas
   ---------------------------------------------------------
   PARA ADICIONAR UMA NOVA ABA:
   1. Copie uma página (ex.: expotech.html) e renomeie.
   2. Adicione uma linha na lista PAGINAS abaixo.
   Pronto: ela aparece no menu, no botão Menu e no rodapé.
   ========================================================= */
// topo: true = aparece também na barra do topo no computador (o Menu sempre mostra todas)
const PAGINAS = [
  { href: "index.html",         nome: "Início",        desc: "Visão geral do DOMUS AI" },
  { href: "como-funciona.html", nome: "Plataforma",    desc: "Dados, análises e recomendações", topo: true },
  { href: "produtos.html",      nome: "Produtos",      desc: "Central, sensores e atuadores DOMUS", topo: true },
  { href: "app.html",           nome: "App",           desc: "O DOMUS na mão do morador", topo: true },
  { href: "cidades.html",       nome: "Cidades",       desc: "Onde atuamos e quem avalia", topo: true },
  { href: "planos.html",        nome: "Planos",        desc: "Do apartamento à casa completa", topo: true },
  { href: "demo.html",          nome: "Demonstração",  desc: "Simule um problema e resolva", topo: true },
  { href: "sobre.html",         nome: "Sobre",         desc: "Missão e valores da DOMUS" },
  { href: "expotech.html",      nome: "ExpoTech",      desc: "Como vamos apresentar o projeto" },
];

/* Atalhos rápidos que aparecem dentro do botão Menu */
const ATALHOS = [
  { href: "demo.html",                    nome: "Testar a demonstração agora" },
  { href: "demo.html#simulador",          nome: "Simular um vazamento" },
  { href: "cidades.html#mapa",           nome: "Ver cidades atendidas" },
  { href: "cidades.html#avaliacoes",      nome: "Ler avaliações das empresas" },
  { href: "produtos.html",                nome: "Ver todos os produtos" },
  { href: "planos.html#comparar",         nome: "Comparar planos" },
  { href: "planos.html#duvidas",          nome: "Dúvidas frequentes" },
];

const REDES = [
  { href: "https://www.instagram.com/domus.ia.tech/", nome: "@domus.ia.tech", rede: "Instagram",
    svg: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg>' },
  { href: "https://x.com/DOMUS_IA", nome: "@DOMUS_IA", rede: "X",
    svg: '<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M17.75 3h3.07l-6.7 7.66L22 21h-6.17l-4.83-6.32L5.47 21H2.4l7.17-8.2L2 3h6.33l4.37 5.77L17.75 3Zm-1.08 16.2h1.7L7.4 4.73H5.58L16.67 19.2Z"/></svg>' },
  { href: "https://www.tiktok.com/@domusia21", nome: "@domusia21", rede: "TikTok",
    svg: '<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M16.6 3c.3 2.2 1.6 3.7 3.9 3.9v3.1c-1.4.1-2.7-.3-3.9-1.1v5.9c0 3.4-2.3 6.2-6 6.2-3.3 0-5.9-2.6-5.6-6.1.3-3 2.9-5.2 6.1-4.9v3.2c-1.5-.3-2.9.6-3 2-.2 1.5 1 2.7 2.5 2.7 1.6 0 2.6-1.1 2.6-2.9V3h3.4Z"/></svg>' },
];

(function () {
  document.documentElement.classList.add("js");
  const atual = (location.pathname.split("/").pop() || "index.html").replace(/\.html$/, "") || "index";
  const ehAtual = (href) => href.replace(/\.html$/, "") === atual ? ' aria-current="page"' : "";
  const redes = REDES.map(r => `<a href="${r.href}" target="_blank" rel="noopener" aria-label="${r.rede} do DOMUS AI">${r.svg}${r.nome}</a>`).join("");
  const marca = `<a class="brand" href="index.html" aria-label="DOMUS AI, início"><img src="img/logo.webp" alt="" width="48" height="23"><span>DOMUS <b>AI</b></span></a>`;

  /* cabeçalho */
  const header = document.getElementById("site-header");
  if (header) {
    header.innerHTML = `
      <div class="wrap">
        ${marca}
        <nav class="nav-links" aria-label="Páginas">${PAGINAS.filter(p => p.topo).map(p => `<a href="${p.href}"${ehAtual(p.href)}>${p.nome}</a>`).join("")}</nav>
        <button class="menu-btn" type="button" aria-expanded="false" aria-controls="drawer"><span class="bars" aria-hidden="true"><i></i><i></i><i></i></span><span>Menu</span></button>
      </div>`;
    const drawer = document.createElement("div");
    drawer.className = "drawer"; drawer.id = "drawer";
    drawer.innerHTML = `
      <div class="drawer-panel" role="dialog" aria-modal="true" aria-label="Menu do site">
        <div><h4>Páginas</h4><nav class="drawer-links">${PAGINAS.map(p => `<a href="${p.href}"${ehAtual(p.href)}><span>${p.nome}<small>${p.desc}</small></span></a>`).join("")}</nav></div>
        <div><h4>Atalhos</h4><div class="shortcuts">${ATALHOS.map(a => `<a href="${a.href}"><span class="dot"></span>${a.nome}</a>`).join("")}</div></div>
        <div><h4>Acompanhe o projeto</h4><div class="social">${redes}</div></div>
      </div>`;
    header.after(drawer);

    const btn = header.querySelector(".menu-btn");
    const abrir = (sim) => {
      document.body.classList.toggle("menu-open", sim);
      btn.setAttribute("aria-expanded", String(sim));
      btn.querySelector("span:last-child").textContent = sim ? "Fechar" : "Menu";
      if (sim) drawer.querySelector("a").focus({ preventScroll: true });
    };
    btn.addEventListener("click", () => abrir(!document.body.classList.contains("menu-open")));
    drawer.addEventListener("click", (e) => { if (e.target === drawer || e.target.closest("a")) abrir(false); });
    document.addEventListener("keydown", (e) => { if (e.key === "Escape" && document.body.classList.contains("menu-open")) { abrir(false); btn.focus(); } });
  }

  /* rodapé */
  const footer = document.getElementById("site-footer");
  if (footer) {
    footer.innerHTML = `
      <div class="wrap">
        <div>${marca}<p class="tag">Sua casa, finalmente inteligente</p></div>
        <nav class="foot-links" aria-label="Rodapé">${PAGINAS.map(p => `<a href="${p.href}">${p.nome}</a>`).join("")}</nav>
        <div class="foot-bottom"><div class="social">${redes}</div><span>Projeto apresentado na ExpoTech 2026</span></div>
      </div>`;
  }

  /* animação suave das seções ao rolar a página */
  const itens = document.querySelectorAll(".reveal");
  if ("IntersectionObserver" in window && !matchMedia("(prefers-reduced-motion: reduce)").matches) {
    const io = new IntersectionObserver((es) => es.forEach(e => { if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); } }), { threshold: 0.15, rootMargin: "0px 0px -40px 0px" });
    itens.forEach(el => io.observe(el));
  } else itens.forEach(el => el.classList.add("in"));
})();
