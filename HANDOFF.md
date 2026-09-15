# Handoff: Zeus Frames — "Viewfinder" website (desktop + mobile)

## Overview
Marketing site for **Zeus Frames**, a Toronto (North York) media studio: video production, photography, social content, a physical studio, event coverage. Goal of the site: show packages fast and get visitors to a quote. Brand is strictly black & white. The concept is a camera **viewfinder**: HUD chrome (REC, timecode, frame counter, exposure readout), an autofocus reticle that follows the cursor, lens-style rings, shutter/flash transitions.

5 pages, one shared shell: **Home · Services · Studio · Packages · Get a Quote**.

## About the design files
Everything in this bundle is a **design reference built in HTML** (a live prototype), not production code. Recreate it in the target stack (Next.js/React recommended; any framework is fine) using its own component and routing conventions. Do not ship the `.dc.html` / `support.js` runtime.

Open `Zeusframes Site.dc.html` in a browser to see the desktop design; `#services`, `#studio`, `#packages`, `#contact` in the URL switch pages. `Zeusframes Mobile.dc.html` shows the same site inside 402px phone frames (it embeds the site file with `?embed=1`). `Zeusframes Logo Animation.dc.html` isolates the logo draw-in animation.

## Fidelity
**High-fidelity.** Colors, type, spacing, copy, motion timings are final intent. Recreate pixel-close. Copy/prices are placeholders approved for prototype — confirm with the client before launch.

## Breakpoint
Single breakpoint: **mobile < 760px**, desktop ≥ 760px. All mobile differences below are driven by that one flag.

---

## Design tokens

Colors
- Ink / background: `#0c0c0c` (page), `#000` (hero/lightbox), `#1a1a1a` (media placeholder tiles)
- Paper (text, strokes, fills): `#ecebe6`
- Hairlines: `rgba(236,235,230,.22)`; stronger hairline/dashed rings: `rgba(236,235,230,.5)`
- HUD chrome is pure `#fff` with `mix-blend-mode: difference` (so it inverts over bright video)
- No accent color. Never light backgrounds (client request: always dark).

Typography (Google Fonts)
- Display: `Cormorant Garamond` 300, italic 300 for the emphasised word (`<em>`) in every heading
- UI/mono: `DM Mono` 400/500
- Heading scale: page H1 `clamp(60px, 11vw, 190px)` line-height .88 letter-spacing -.025em; section H2 `clamp(46px, 7vw, 120px)` lh .9; sub H2 `clamp(40px, 5.4vw, 92px)`; card H3 `clamp(26px, 2.6vw, 40px)` lh 1
- Label style (used everywhere for kickers, nav, buttons): DM Mono 10px, letter-spacing .2em, uppercase, opacity .65 when secondary
- Body: DM Mono 13–15px, line-height 1.7–1.8, opacity .8

Spacing
- Page gutter: `6vw`; HUD inset: 36px (corner brackets at 16px)
- Section padding: 120–160px top/bottom; 130px on inner pages
- Card padding: 30–34px; grids gap 24px (or 1px hairline grids using background = hairline color)

Shape
- No border-radius except pills (`999px`) for chips/buttons and circles for rings. Cards are square-cornered 1px hairline boxes.
- No shadows except the floating pills (`0 12px 40px rgba(0,0,0,.4)`).

Motion
- Standard ease: `cubic-bezier(.2,.7,.2,1)`; mechanical/shutter ease: `cubic-bezier(.76,0,.24,1)`; draw-in ease `cubic-bezier(.65,0,.2,1)`
- Scroll reveal: opacity 0→1 + translateY 30px→0, 1s; variants `up` (clip-path inset from bottom, 1.1s) and `iris` (clip-path circle 0%→75%, 1.4s)
- Honor `prefers-reduced-motion`: disable all animations/transitions, reveal everything.

---

## Global shell (every page)

**Intro (first load only, not on client-side page change, skipped when `?embed=1`)**
Black full-screen. The logo mark draws itself in (see "Logo animation", 1.7s, stroke 6) centered at 72×80px; at 1.7s an **iris** opens (a circle with a 250vmax black box-shadow whose width/height animate 0→300vmax over 1.7s, ease mechanical). Hero text starts at 1.9s. Overlay removed at 3.5s.

**HUD (fixed, z 500, pointer-events none except buttons, white + difference blend)**
- 18×18 corner brackets at 16px from each corner (1px lines).
- A fixed dark scrim sits behind the top row on all sizes: `linear-gradient(180deg, rgba(12,12,12,.92) 0%, rgba(12,12,12,.7) 45%, transparent 100%)`, height 120px desktop / 96px mobile.
- Top row at 26px / 36px inset: left = logo mark (28×31 vector) + `/ PAGE NAME` label (desktop only); center = blinking 7px dot + `REC` + live timecode `HH:MM:SS:FF` (desktop only, 250ms tick); right = `Get a quote` (underlined) + `Menu ≡` (all sizes).
- Bottom-right (desktop): `FR 0000 / 1000` = scroll progress ×1000. Bottom corner brackets are desktop only.
- **Navigation = full-screen menu on all sizes** (no rail). `Menu ≡` opens a `#0c0c0c` overlay (fade .35s): list of 5 pages, each row = number `01`–`05` + Cormorant title `clamp(30px,5.5vw,76px)` + hairline bottom; hover shifts padding-left 12px and lifts opacity .6→1; desktop shows a right-aligned hint per row (`Video · Social · Events`, … / `You are here` for the current page) and a second column with Call / Email / Studio / Social. Bottom row: horizontal lockup logo + `Close ✕` pill. Clicking any item closes the menu and jumps to the top of the target page; Esc closes.
- AF reticle (desktop only): 44×44 box made of four 10px corner brackets (1.5px), fixed, follows the cursor (offset −22,−22) with `transform .22s`. On hover of any CTA/card/nav item it **locks**: moves to the element's bounding box +8px padding (width/height animate .35s). Unlocks on mouseleave or scroll.
- Back-to-top (desktop): 44px round button, fixed right 20px bottom 60px, `rgba(12,12,12,.72)` + blur + `rgba(236,235,230,.4)` border, shows after 1 viewport of scroll.
- Range pill (after the visitor has toggled any estimator chip, all pages except Contact): fixed bottom-center pill `Your range  $X – $Y  →` (paper background, ink text) linking to Contact. Bottom 28px desktop / 80px mobile.
- Mobile dock (mobile only): fixed bottom 44px, inset 16px, grid `1fr 1fr 48px 48px` gap 8px, all 48px tall: `WhatsApp` (filled pill → `https://wa.me/16478391491`), `Call` (outline pill → `tel:+16478391491`), round `→` (Get a quote), round `↑` (back to top, .45 border). Behind it a 120px bottom gradient scrim (`rgba(12,12,12,.95)` → transparent). Range pill sits at bottom 104px on mobile.

**Page change behavior**
Client-side switch; **scroll jumps to top instantly** (no smooth), hash updates (`#services`), reveals/observers re-attach, AF unlocks, lightboxes close. In-page anchors keep smooth scrolling.

**Hero (every page)**
Full-bleed muted looping video (`object-fit: cover`, grayscale, `contrast 1.1`), 100vh on Home, 82vh desktop / 86vh mobile elsewhere; min 560px. Overlay: radial vignette + vertical gradient to 60% black. Enter animation `focusPull`: blur 16px→0 + scale 1.06→1, 2.4s. A 26px 1px square blinks twice at center (AF confirm). Content block at bottom-left 6vw / 13vh: kicker label → H1 in two lines (line 2 italic, indented .18em) rising in with clip-path → lead paragraph (max 460px) + CTAs: round 56px paper button with 3px black + 1px paper ring + `Get a quote` label; text link `See the work` (underline .5 opacity).

Hero copy per page (kicker / line1 / line2 / lead):
- Home: `Toronto media studio · Video · Photo · Social` / Everything / in focus. / "Video, photography and social content from a North York studio — for brands, creators and families who want to be remembered."
- Services: `Services · Video · Social · Events` / Three lenses, / one crew. / "Brand films, a monthly content engine and live event coverage — scripted, shot and graded by the same people."
- Studio: `The studio · 85mm · f/1.8` / A room built / for light. / "Portraits, products, podcasts and lookbooks in North York — crew, kit and edit included."
- Packages: `Packages · Live estimate` / Know the cost / before you call. / "Monthly subscriptions and single sessions, with a builder that gives you a real range in seconds."
- Contact: `Get a quote · Two working days` / Tell us what / you're making. / "Three questions and you have a range. We confirm the exact number, the dates and what to bring."

**Footer (every page)**: 4 columns (auto-fit, min 200px): horizontal lockup logo (38px tall) + one-liner; Pages list; Studio address + hours; Contact + Instagram. Bottom hairline row: `© 2026 Zeus Frames Inc.` / `Toronto, Canada`. Above the footer on every page except Contact: a full-width hairline band `Get a quote` (Cormorant clamp 40–120px) + `Three questions · a range in 60 seconds →`.

---

## Pages

### 1. Home
1. Hero (above).
2. **Selected work** — H2 + label `Hover to focus · Click to shoot`. 3-col grid (1-col mobile), gap 28×24, tiles 16:10 on `#1a1a1a`, grayscale muted video (lazy: `src` set only when near viewport; plays on hover, seeks 0.05s so a frame paints). Hover = **depth of field**: hovered tile scales 1.04, all other tiles blur 6px + opacity .5. Corner label `F01…F06` top-left, title bottom-right, both `#fff` difference. Caption row: title / category ↗ (links to Instagram, stops propagation). Click = **shutter**: two black blades close from top/bottom (0.7s), white flash at 62%, then full-screen lightbox (black, video `object-fit: contain`, header `F01 — Brand film · Close ✕`, italic Cormorant title bottom). Click anywhere closes.
   Data: Royal Snooker/Brand film, Studio portraits/Photography, Mr. Snooker/Social reels, Downtown launch/Event recap, Product story/Commerce, Toronto from above/Aerial.
3. **What we make** — 2-col (list | sticky lens); **on mobile the lens is hidden** and the list is full-width. Left: 4 rows (`01 Video Production 24mm`, `02 Social Marketing 35mm`, `03 Studio 85mm`, `04 Events 50mm`), each 72vh tall on desktop, hairline top, H3 Cormorant clamp 30–78px, paragraph, text-link CTA to Services/Studio. Row opacity 1 when active else .4. Right: sticky circular **lens** (`min(38vw,70vh)`, mobile 32vw sticky at 72px): dashed ring at −18px that rotates with scroll (`rotate(scrollY/9 deg)`), 1px ring at −6px, clipped circle with 4 stacked videos; video *i* reveals with `clip-path: circle(0%→75%)` 1.1s as row *i* enters the middle 20% of the viewport. Logo mark 34×38 at the lens centre (difference blend). Label under lens `01 — Video Production · 24mm`.
4. **Studio teaser** — 2-col: text (label `Studio · North York` / `85mm · f/1.8`, H2 "A room *built* for light.", paragraph, three stats `$250 per reel`, `$499 subscription / month`, `10% off · 3-month contract`, outline button `See the studio →`) | 4:5 image with iris reveal.
5. **The mark** — full-viewport stage (min-height 100vh, hairline top/bottom). Centered square `min(84vh,88vw)` (mobile `min(80vh,92vw)`) containing an SVG (viewBox 1000): rotating outer circular text ring `ZEUS FRAMES · CREATIVE BRAND AGENCY · TORONTO · VIDEO · PHOTO · SOCIAL · STUDIO · EVENTS ·` (r 462, 120s/rev), 1px ring r 440 with 72 minor + 12 major ticks rotating 90s/rev, dashed ring r 372 with two bright quarter arcs rotating reverse 45s/rev, ring r 318, pulsing ring r 300 (5s), four N/S/E/W ticks + letters, four AF corner brackets at (270,270)… with HUD labels `AF · LOCK`, `ISO 800`, `f/1.8`, `1/50`. In the centre the **logo draws in over 6s when the stage enters view (≥40% visible)**, and at ~70% of that animation a shutter **flash** fires: full-stage paper overlay opacity 0→.85→0 (66%→70%→78%) + a blurred burst circle behind the mark. Animation is `paused` until in view, runs once.
6. **How it runs** — 4 hairline cards (auto-fit min 220px, min-height 240): 01 Discovery / 02 Pre-production / 03 Shoot day / 04 Delivery with short paragraphs.
7. **About** (folded into Home) — 2-col intro ("A small crew with a *big* lens." + two paragraphs), stats row (`24 Projects delivered`, `6 Industries served`, `48h First cut turnaround`, `1 Studio in North York`), **The crew** 4 cards (3:4 image, role, one line: Director / Camera / Editor / Producer), **What we believe** 4 numbered rows (The story first / One roof / Real prices / Made to be posted).

### 2. Services (three chapters on one page)
- Sticky **anchor bar** under the HUD (top 64px, page background, hairline bottom): three pill links `Video production 24mm`, `Social marketing 35mm`, `Events 50mm` → `#svc-video`, `#svc-social`, `#svc-events`.
- Each chapter opens with a hairline-topped header row: H2 (`Video *production*` / `Social *marketing*` / `Event *coverage*`) + right label (`01 · 24mm · from $499`, `02 · 35mm · from $499 / mo`, `03 · 50mm · from $400`).
- **Video**: 2-col intro ("Films that *sell* without looking like ads." + paragraph); 6 hairline cards (3-col, min-height 250): Commercials 24mm from $1,500 · Brand films 35mm from $2,500 · Product 100mm from $499 · Real estate 16mm from $1,200 · Music videos 50mm from $1,800 · Documentary 85mm on request; **The full production** checklist: 12 items in auto-fit columns (Concept and script … Licensed music), each `NN` + label with hairline top.
- **Social**: 2-col intro ("One shoot day. A *month* of content."); 6 cards (Content days, Editing and captions, Scheduling, Community, Reporting, Paid support); **Vertical first** block: text with stats `8 reels / month`, `3 cuts per reel`, `48h first delivery` | 3 × 9:16 video tiles (iris reveal, play on hover).
- **Events**: 2-col intro ("Filmed live. Posted *while* it still matters."); 6 cards with prices (Launches from $700, Corporate from $1,200, Tournaments from $900, Openings from $600, Family from $400, Same-week recap +$300); **Event day** timeline: 5 columns (`−1 wk Walkthrough`, `T−2h Load in`, `Live Coverage`, `+48h Recap cut`, `+5d Full set`).
- Closing **Across all *three*** work grid (same component as Home, 6 items S01–S06).

### 3. Studio
- 2-col intro ("Book the room, *keep* the crew." + paragraph).
- Gallery: 4-col grid (2-col mobile), gap 16, iris reveal, hover scale 1.04: 16:10 span 2 · 4:5 · 4:5 · 4:5 · 16:10 span 3 (mobile: wide tiles span full row).
- **Kit list**: 2-col (label + H2 "Kit *list*" + paragraph | 6 numbered rows: Cinema bodies, Lighting, Sound, Sets, Client space, Crew).
- **Studio rates**: header + label `Extra time $100 / hr`; 4 hairline rows (`01 Half day in studio $450`, `02 Full day in studio $850`, `03 Podcast session $350`, `04 Portrait session $250`), grid `90px | 1fr | auto`, hover shifts padding-left 14px.

### 4. Packages
- 2-col intro ("Pick a *plan* or build your own.").
- Tabs (pills, active = paper bg/ink text): **Monthly** / **Projects** / **Single sessions**. Cards animate in with `zoom` (opacity+scale .94) staggered .12s.
  - Monthly: Basic Presence $499 /mo (Starter) · Pro Essentials $1,990 /mo (Most popular) · Elite Cinematic $4,000 /mo (Full production) — each with 5–6 bullet items and `Choose <name> →`.
  - Projects: Essential $899 · Growth $2,499 · Signature $6,000 (per project).
  - Single sessions: Product $199 · Real estate $499 · Social media $399 · Real estate tour $1,200.
- **Live estimator** (`#estimate`, hairline box, 2-col `1.2fr | 1fr`, mobile stacked with hairline divider): label `Build your package · Live estimate`, H3 "Dial in what you need.", 6 toggle chips (pill, active = paper/ink): `8 reels / month $1.6k–2.4k` (1600–2400) · `Brand film $1.5k–4k` (1500–4000) · `Product photography $200–900` · `Drone coverage $300–600` · `Event coverage $400–1.2k` · `Studio session $250–500`. Defaults on: reels + photo. Right: `Estimated range / month` → Cormorant `$lo – $hi` (sum of selected; en-CA formatting) + note + outline button `Request exact quote →`. Toggling any chip sets a global `touched` flag that shows the Range pill.
- **Add-ons**: 8 hairline rows in auto-fit columns (Extra filming hour $100 / hr, Additional edited photo $50, VFX and motion graphics From $150, Second operator $250 / day, Licensed music track From $80, Rush 24-hour delivery +25%, Drone add-on $300, Subtitles per language $40).
- **Common questions**: 5 accordion rows (first open; `+` rotates 45°, answer max-height/opacity transition .5s). Q/A copy is in the file — confirm with client.

### 5. Get a Quote (Contact)
- 2-col `1.3fr | .7fr` (stacked mobile). Right column: 4:5 image + Call / Email / Studio / Hours / Social.
- Left: 3-step form. Header `Step N of 3 · Scope|Details|Brief`, H2 changes per step ("What are we making?", "Who are we making it for?", "When and why?"), 3 progress bars (2px, opacity 1 done / .25 pending).
  - Step 1: the same 6 estimator chips (shared state) + live range + `Next — your details →`.
  - Step 2: 2-col fields (Name, Email, Phone, Business or brand — underline inputs, 15px), Industry chips (Social / creator, Real estate, Restaurant, Retail, Construction, Fashion, Family; single-select), `← Back` / `Next — the brief →`.
  - Step 3: Start date input, textarea "What's the content for?", `← Back` / `Send the request →`.
  - Sent state: hairline box with drawing logo (34×38) + `Request logged`, italic H3 "Thanks — we'll come back within two working days.", paragraph repeating the range, `Start another request`.
- No backend in the prototype; validation is not implemented (add soft email/phone validation in production).

---

## Logo

Vector mark reconstructed from the client PNG (pixel IoU 96.6%). `assets/logo-mark.svg` = final static mark (viewBox `0 0 485 541`, single `fill-rule="evenodd"` path). `assets/logo-paths.json` = the 5 sub-paths (`hex` outer rounded hexagon, `tri` central inverted triangle cut-out, `cap` top cut-out, `kl`/`kr` side cut-outs) used for the draw-in.

**Logo draw-in animation** (duration D; used at 1.7s intro, 2.4s sent-state, 6s brand stage):
- Five hairline strokes (`pathLength=1`, `stroke-dasharray:1`), color paper, width 4–6:
  - hex: dashoffset 1→0 over 0–42% of D
  - tri: 18%–58%
  - cap, kl, kr: 40%–72%
- Filled mark: opacity 0 until 62%, 1 by 84%
- Stroke group fades out 80%→94%
- Easing draw `cubic-bezier(.65,0,.2,1)`
- Idle treatment (where the mark sits in a ring): dashed circle rotating 26–40s/rev, pulsing 1px circle 4–5s.

PNG lockups (transparent): `logo-h-white/black.png` horizontal "ZEUS FRAMES · Creative Brand Agency" (used in footer + mobile menu), `logo-v-white.png` vertical, `logo-mark-white/black.png` mark only.

---

## Media
All video/photo in the prototype is **placeholder stock** (Pexels video downloads, Unsplash photos, grayscale filter applied in CSS). Replace with client footage; provide a poster image per clip (the prototype has none — it relies on `preload="metadata"` + seeking to 0.05s to paint a first frame). Lazy-load grid videos (IntersectionObserver), autoplay muted/inline, pause when off-screen. Hide a video that errors (opacity 0) so the `#1a1a1a` tile remains.

## State (client)
`page`, `mob`, `intro`, `tc` (timecode), `lens` (active service row), `wh` (hovered work tile), `lb` (lightbox index), `shot` (shutter running), `menu`, `tab`, `faq`, `pk` (estimator selections — shared across Packages & Contact), `touched`, `step`, `sent`, `form`, `brandSeen`.

## Contact data
+1 647-839-1491 · Zeusframess@gmail.com · 180 Shaughnessy Blvd, North York, ON M2J 1K3 · Mon–Sat 9:00–19:00 · instagram.com/zeusframes.inc

## Files in this bundle
- `Zeusframes Site.dc.html` — full desktop/mobile site (source of truth; template + logic class inside)
- `Zeusframes Mobile.dc.html` + `ios-frame.jsx` — phone showcase (embeds the site at 402px)
- `Zeusframes Logo Animation.dc.html` — isolated logo animation with replay
- `support.js` — prototype runtime (reference only, do not ship)
- `assets/` — logo SVG, path JSON, PNG lockups
