// Service Worker — Partes GlobalFeed
// Estrategia: Network-first para HTML y APIs, caché solo para assets estáticos
const CACHE = 'partespro-gf-v9';
const STATIC = ['./icon-192.png','./icon-512.png','./apple-touch-icon.png','./logo.png','./manifest.json'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => Promise.allSettled(STATIC.map(u => c.add(u).catch(() => {}))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const url = e.request.url;
  const method = e.request.method;

  // NUNCA cachear peticiones POST/PATCH/DELETE ni APIs externas ni HTML
  if (
    method !== 'GET' ||
    url.includes('supabase.co') ||
    url.includes('script.google.com') ||
    url.includes('groq.com') ||
    url.includes('googleapis.com') ||
    url.includes('fonts.gstatic') ||
    url.includes('cdnjs.cloudflare.com') ||
    e.request.destination === 'document'
  ) {
    e.respondWith(
      fetch(e.request).catch(() => {
        if (e.request.destination === 'document') return caches.match('./index.html');
        return new Response('', {status: 408});
      })
    );
    return;
  }

  // Solo GET de assets estáticos: caché primero, red como fallback
  e.respondWith(
    caches.match(e.request).then(cached => {
      if (cached) return cached;
      return fetch(e.request).then(r => {
        if (r && r.status === 200 && r.type !== 'opaque') {
          const clone = r.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone).catch(() => {}));
        }
        return r;
      }).catch(() => new Response('', {status: 408}));
    })
  );
});
