/* DOMUS AI · página App: abas das funções do app (mesmo funcionamento das abas de Cidades).
   O conteúdo de cada função fica no próprio app.html (cada função é um <article class="ct-panel">). */
(function () {
  const abas = [...document.querySelectorAll(".ct-tabs button")];
  const paineis = [...document.querySelectorAll(".ct-panel")];
  if (!abas.length) return;
  const abrir = (slug, foco) => {
    abas.forEach(b => { const on = b.dataset.c === slug; b.setAttribute("aria-selected", on); b.tabIndex = on ? 0 : -1; if (on && foco) b.focus(); });
    paineis.forEach(p => { const on = p.id === "pn-" + slug; p.hidden = !on; p.classList.toggle("in", on); });
  };
  abas.forEach((b, i) => {
    b.addEventListener("click", () => abrir(b.dataset.c));
    b.addEventListener("keydown", (e) => {
      const d = e.key === "ArrowRight" ? 1 : e.key === "ArrowLeft" ? -1 : 0;
      if (d) { e.preventDefault(); abrir(abas[(i + d + abas.length) % abas.length].dataset.c, true); }
    });
  });
  const hash = location.hash.replace("#", "");
  abrir(abas.some(b => b.dataset.c === hash) ? hash : abas[0].dataset.c);
})();
