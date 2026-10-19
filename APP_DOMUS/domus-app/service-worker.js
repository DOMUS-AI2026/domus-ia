// DOMUS AI — Service Worker
// Versão do cache — incrementar ao fazer deploy de novas versões
const CACHE_NAME = 'domus-ai-v6';

// Arquivos que ficam disponíveis offline (shell do app)
const SHELL_ASSETS = [
  '/domus-html.html',
  '/manifest.json',
  '/assets/icon-192.png',
  '/assets/icon-512.png',
  '/assets/cam_sala.jpg',
  '/assets/cam_cozinha.jpg',
  '/assets/cam_escritorio.jpg',
  '/assets/cam_quarto1.jpg',
  '/assets/cam_quarto2.jpg',
  '/assets/cam_suite.jpg',
  '/assets/cam_banheiro.jpg',
  '/assets/cam_banhosuite.jpg',
  '/assets/cam_lavanderia.jpg',
  '/assets/cam_sala_pessoa.jpg',
  '/assets/cam_cozinha_pessoa.jpg',
  '/assets/cam_escritorio_pessoa.jpg',
  '/assets/cam_quarto1_pessoa.jpg',
  '/assets/cam_quarto2_pessoa.jpg',
  '/assets/cam_suite_pessoa.jpg',
  '/assets/cam_lavanderia_pessoa.jpg'
];

// ─── INSTALL: pré-carrega o shell do app no cache ───────────────────────────
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[DOMUS SW] Pré-cacheando shell do app...');
      return cache.addAll(SHELL_ASSETS);
    }).then(() => self.skipWaiting())
  );
});

// ─── ACTIVATE: remove caches antigos ao atualizar ───────────────────────────
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

// ─── FETCH: estratégia "Cache First" para assets locais ─────────────────────
// Recursos externos (CDN, Supabase, Fonts) sempre vão para a rede
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // Supabase, CDN (Three.js, Google Fonts) → sempre busca na rede
  if (
    url.hostname.includes('supabase.co') ||
    url.hostname.includes('cdn.jsdelivr.net') ||
    url.hostname.includes('fonts.googleapis.com') ||
    url.hostname.includes('fonts.gstatic.com')
  ) {
    return; // deixa o browser cuidar normalmente
  }

  // Páginas HTML → Network First (sempre pega a versão nova; cache só se estiver offline)
  if (event.request.mode === 'navigate' || url.pathname.endsWith('.html')) {
    event.respondWith(
      fetch(event.request).then((response) => {
        if (response && response.status === 200) {
          const copy = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
        }
        return response;
      }).catch(() => caches.match(event.request).then((c) => c || caches.match('/domus-html.html')))
    );
    return;
  }

  // Assets locais → Cache First com fallback pra rede
  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;

      return fetch(event.request).then((response) => {
        // Só cacheia respostas válidas
        if (!response || response.status !== 200 || response.type === 'opaque') {
          return response;
        }
        const toCache = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, toCache));
        return response;
      });
    })
  );
});

// ─── PUSH NOTIFICATIONS (preparado para uso futuro com Supabase) ────────────
self.addEventListener('push', (event) => {
  const data = event.data ? event.data.json() : {};
  const title = data.title || 'DOMUS AI';
  const options = {
    body: data.body || 'Alerta da sua residência',
    icon: '/assets/icon-192.png',
    badge: '/assets/icon-192.png',
    vibrate: [200, 100, 200],
    data: { url: data.url || '/domus-html.html' }
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    clients.openWindow(event.notification.data.url || '/domus-html.html')
  );
});
