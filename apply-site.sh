#!/usr/bin/env bash
# Turns a raw "Zeusframes Site v2.dc.html" design export into this repo's index.html.
#
# The design export is a prototype: it hotlinks stock media and routes pages with
# #hash only. This script applies the deployment changes we need, all of which are
# additive to the designer's markup:
#   1. media served from local assets/ (resolved from the site root at runtime)
#   2. clean path URLs (/motherhood-family/ ...) with pushState + back/forward
#   3. /contact/?service=... pre-fills the inquiry form
#   4. a service/package CTA lands on the inquiry form instead of the page top
#   5. a runtime fix: the page-change hook never received previous state
#
# Usage: bash apply-site.sh "/path/to/Zeusframes Site v2.dc.html"
# Then:  bash build-pages.sh
set -euo pipefail
cd "$(dirname "$0")"
SRC="${1:?usage: apply-site.sh <path to Zeusframes Site vN.dc.html>}"
[ -f "$SRC" ] || { echo "no such file: $SRC" >&2; exit 1; }

python - "$SRC" <<'PY'
import io, re, sys
src = sys.argv[1]
s = io.open(src, encoding='utf-8').read()
def need(old, label):
    if old not in s:
        raise SystemExit('apply-site: anchor not found (%s) — design export changed, patch needs review' % label)

# ---- 1. media from local assets, addressed from the site root -----------------
need('const S = this.state, V = id => `https://www.pexels.com/download/video/${id}/`', 'media helpers')
s = s.replace(
    'const S = this.state, V = id => `https://www.pexels.com/download/video/${id}/`, '
    'U = (id, w) => `https://images.unsplash.com/photo-${id}?w=${w || 1200}&q=80&auto=format`;',
    'const S = this.state, AB = this.routeBase(), V = id => `${AB}assets/video/${id}.mp4`, '
    'U = id => `${AB}assets/img/${id}.jpg`;')
s = re.sub(r"\.map\(id => 'https://images\.unsplash\.com/photo-' \+ id \+ '\?[^']*'\)",
           ".map(id => AB + 'assets/img/' + id + '.jpg')", s)
s = re.sub(r'https://images\.unsplash\.com/photo-([A-Za-z0-9-]+)\?[^"\'&]*(&amp;[^"\']*)?',
           r'{{ assetBase }}assets/img/\1.jpg', s)
s = re.sub(r'https://www\.pexels\.com/download/video/([0-9]+)/',
           r'{{ assetBase }}assets/video/\1.mp4', s)
s = s.replace('src="assets/', 'src="{{ assetBase }}assets/')
need('      svcOpts: this.SVC_OPTS,', 'render values')
s = s.replace('      svcOpts: this.SVC_OPTS,', '      assetBase: AB, svcOpts: this.SVC_OPTS,', 1)
left = [m for m in re.findall(r'https://(?:images\.unsplash|www\.pexels)[^"\'\s)`]*', s)
        if '${' not in m]
if left:
    raise SystemExit('apply-site: stock media still hotlinked: %s' % left[:3])

# ---- 2. clean path URLs ------------------------------------------------------
# Slugs follow the designer's own canonical map in applySeo().
need('  PAGES = [', 'PAGES')
s = re.sub(r'(  PAGES = \[[^\]]*\];)', r"""\1
  SLUGS = { home: '', video: 'motherhood-family', social: 'fashion-branding', events: 'commercial-music-video', studio: 'studio-rental', packages: 'packages', portfolio: 'portfolio', about: 'about', contact: 'contact' };
  ALIASES = { 'commercial-video': 'events', 'experience-pricing': 'packages' };
  SVC_PARAM = { journey: '__journey', kidsgraphy: 'kids', motherhood: 'maternity', studio: 'studio-rental', fashion: 'fashion-branding', branding: 'creator', commercial: 'commercial-video', 'music-video': 'music' };
  routeBase() { const segs = location.pathname.split('/').filter(Boolean); const last = segs[segs.length - 1]; const known = Object.values(this.SLUGS).filter(Boolean).concat(Object.keys(this.ALIASES)); if (last && (known.includes(last) || /\\.html?$/i.test(last))) segs.pop(); return '/' + segs.join('/') + (segs.length ? '/' : ''); }
  pageForSlug(x) { if (!x) return null; if (this.PAGES.includes(x)) return x; if (this.ALIASES[x]) return this.ALIASES[x]; return this.PAGES.find(k => this.SLUGS[k] === x) || null; }
  pageFromLocation() { const segs = location.pathname.split('/').filter(Boolean); return this.pageForSlug(segs[segs.length - 1] || '') || this.pageForSlug(new URLSearchParams(location.search).get('page')) || this.pageForSlug(location.hash.replace('#', '')); }
  urlFor(page) { return this.routeBase() + (this.SLUGS[page] ? this.SLUGS[page] + '/' : '') + (this.embed ? '?embed=1' : ''); }
  syncUrl(page, replace) { const want = this.urlFor(page); if (location.pathname + location.search === want) return; try { history[replace ? 'replaceState' : 'pushState']({ page }, '', want); } catch (e) {} }
  applyServiceParam() { const v = (new URLSearchParams(location.search).get('service') || '').toLowerCase(); if (!v) return; const k = this.SVC_PARAM[v] || v; if (k === '__journey' || this.svcLabel(k)) this.applySvc(k); }
  scrollToId(id, delay) { [delay || 900, (delay || 900) + 600].forEach(ms => setTimeout(() => { const el = document.getElementById(id); if (el) window.scrollTo({ top: el.getBoundingClientRect().top + window.scrollY - 90, behavior: 'instant' }); }, ms)); }""",
           s, count=1)

need("""    const h = (location.hash || '').replace('#', ''), pv = this.props.page;
    if (this.PAGES.includes(h)) this.setState({ page: h });
    else if (this.PAGES.includes(pv)) this.setState({ page: pv });""", 'mount routing')
s = s.replace("""    const h = (location.hash || '').replace('#', ''), pv = this.props.page;
    if (this.PAGES.includes(h)) this.setState({ page: h });
    else if (this.PAGES.includes(pv)) this.setState({ page: pv });""",
"""    this.embed = /(\\?|&)embed=1/.test(location.search);
    const pv = this.props.page;
    const initial = this.pageFromLocation() || (this.PAGES.includes(pv) ? pv : 'home');
    if (initial !== this.state.page) this.setState({ page: initial });
    this.applySeo(initial);
    this.applyServiceParam();
    this.syncUrl(initial, true);
    this.onPop = () => { const x = this.pageFromLocation(); if (x && x !== this.state.page) { this.popNav = true; this.jumpTop(); this.setState({ page: x, menu: false }); this.applySeo(x); this.applyServiceParam(); } };
    window.addEventListener('popstate', this.onPop);""", 1)

s = s.replace("this.onHash = () => { const x = location.hash.replace('#', ''); if (this.PAGES.includes(x) && x !== this.state.page)",
              "this.onHash = () => { const x = this.pageForSlug(location.hash.replace('#', '')); if (x && x !== this.state.page)", 1)

need("      if (location.hash !== '#' + this.state.page) history.replaceState(null, '', '#' + this.state.page);", 'url sync on page change')
s = s.replace("      if (location.hash !== '#' + this.state.page) history.replaceState(null, '', '#' + this.state.page);",
              "      this.syncUrl(this.state.page, !!this.popNav); this.popNav = false;", 1)

s = s.replace("window.removeEventListener('scroll', this.onScrollB);",
              "window.removeEventListener('popstate', this.onPop); window.removeEventListener('scroll', this.onScrollB);", 1)

# ---- 3. land on the inquiry form when a CTA carries a service ----------------
need('<form onSubmit="{{ sendInq }}"', 'inquiry form')
s = s.replace('<form onSubmit="{{ sendInq }}"', '<form id="inquiry" onSubmit="{{ sendInq }}"', 1)
s = re.sub(r"const anchor = e\.currentTarget\.dataset\.anchor; if \(anchor\) \{ setTimeout\(\(\) => \{ const el = document\.getElementById\(anchor\); if \(el\) window\.scrollTo\(\{ top: el\.getBoundingClientRect\(\)\.top \+ window\.scrollY - 90, behavior: 'smooth' \}\); \}, 1250\); \}",
           "const anchor = e.currentTarget.dataset.anchor || (p === 'contact' && e.currentTarget.dataset.svc ? 'inquiry' : ''); if (anchor) this.scrollToId(anchor, 1250);", s, count=1)
need("this.jumpTop(); this.setState({ page: 'contact' }); }", 'pickPlan jump')
s = s.replace("this.jumpTop(); this.setState({ page: 'contact' }); }",
              "this.jumpTop(); this.setState({ page: 'contact' }); this.applySeo('contact'); this.scrollToId('inquiry', 1250); }", 1)

# ---- 4. runtime fix: page-change hook is called without previous state -------
need('  componentDidUpdate(pp, ps) {', 'componentDidUpdate')
s = s.replace('  componentDidUpdate(pp, ps) {',
"""  componentDidUpdate(pp, ps) {
    pp = pp || {}; ps = ps || { page: this._prevPage === undefined ? this.state.page : this._prevPage }; this._prevPage = this.state.page;""", 1)

io.open('index.html', 'w', encoding='utf-8', newline='\n').write(s)
print('apply-site: index.html written')
PY
