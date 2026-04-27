// Service Worker — Partes GlobalFeed
// Estrategia: Network-first para HTML, caché solo para assets estáticos (iconos, fuentes)
// Los datos de Supabase NUNCA se cachean

const CACHE = 'partespro-gf-v7';
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

  // NUNCA cachear: Supabase, Google Apps Script, APIs externas, HTML principal
  if (
    url.includes('supabase.co') ||
    url.includes('script.google.com') ||
    url.includes('fonts.googleapis') ||
    url.includes('fonts.gstatic') ||
    url.includes('cdnjs.cloudflare.com') ||
    e.request.destination === 'document'
  ) {
    // Siempre red — nunca caché
    e.respondWith(fetch(e.request).catch(() => caches.match('./index.html')));
    return;
  }

  // Para imágenes/iconos: caché primero, red como fallback
  e.respondWith(
    caches.match(e.request).then(cached => {
      if (cached) return cached;
      return fetch(e.request).then(r => {
        if (r && r.status === 200) {
          const clone = r.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return r;
      });
    })
  );
});
