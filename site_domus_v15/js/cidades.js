/* DOMUS AI · página Cidades: abas das cidades e contadores animados.
   Os números e textos ficam no próprio cidades.html (cada cidade é um <article class="ct-panel">). */
(function () {
  const abas = [...document.querySelectorAll(".ct-tabs button")];
  const paineis = [...document.querySelectorAll(".ct-panel")];
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
  const porHash = (rolar) => {
    const hash = location.hash.replace("#", "");
    if (abas.some(b => b.dataset.c === hash)) { abrir(hash); if (rolar) setTimeout(() => document.getElementById("mapa").scrollIntoView(), 50); return true; }
    return false;
  };
  if (!porHash(true)) abrir(abas[0].dataset.c);
  window.addEventListener("hashchange", () => porHash(true));

  /* contadores: 12.480 sobe de 0 até o valor quando aparece na tela */
  const alvo = (t) => parseFloat(t.replace(/\./g, "").replace(",", "."));
  const formata = (n, original) => original.includes(",") ? n.toFixed(1).replace(".", ",") : Math.round(n).toLocaleString("pt-BR");
  const contar = (el) => {
    const final = el.textContent, v = alvo(final), t0 = performance.now(), dur = 1400;
    const passo = (t) => { const k = Math.min(1, (t - t0) / dur), e = 1 - Math.pow(1 - k, 3); el.textContent = k < 1 ? formata(v * e, final) : final; if (k < 1) requestAnimationFrame(passo); };
    requestAnimationFrame(passo);
  };
  const nums = document.querySelectorAll("[data-count]");
  if ("IntersectionObserver" in window && !matchMedia("(prefers-reduced-motion: reduce)").matches) {
    const io = new IntersectionObserver((es) => es.forEach(e => { if (e.isIntersecting) { contar(e.target); io.unobserve(e.target); } }), { threshold: 0.6 });
    nums.forEach(n => io.observe(n));
  }
})();
