// Fast, offline-ready shell. Versioned scripts, styles and fonts are served instantly from the device (their URL changes when they change);
// pages are fetched fresh and fall back to the last copy if the connection is slow or down. Never caches API data.
const C = 'eddy-shell-v2';
self.addEventListener('install', () => { self.skipWaiting(); });
self.addEventListener('activate', (e) => { e.waitUntil(caches.keys().then((ks) => Promise.all(ks.filter((k) => k !== C).map((k) => caches.delete(k)))).then(() => self.clients.claim())); });
const put = (r, req) => { if (r.ok) { const c = r.clone(); caches.open(C).then((x) => x.put(req, c)); } return r; };
self.addEventListener('fetch', (e) => {
  const u = new URL(e.request.url);
  if (e.request.method !== 'GET' || u.origin !== location.origin || u.pathname.startsWith('/api/') || u.pathname.startsWith('/img/')) return;
  if (/[?&]v=/.test(u.search) || /\.(woff2|png)$/.test(u.pathname)) { // cache first: instant
    e.respondWith(caches.match(e.request).then((m) => m || fetch(e.request).then((r) => put(r, e.request)))); return;
  }
  e.respondWith(new Promise((res) => { // network first, but never make the person wait more than 3 seconds
    const t = setTimeout(() => caches.match(e.request).then((m) => m && res(m)), 3000);
    fetch(e.request).then((r) => { clearTimeout(t); res(put(r, e.request)); }).catch(() => { clearTimeout(t); caches.match(e.request).then((m) => res(m || caches.match('/') || Response.error())); });
  }));
});
