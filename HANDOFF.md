# Handoff: Zeus Frames — "Viewfinder" website (desktop + mobile)

## Overview
Marketing site for **Zeus Frames**, a Toronto (North York) media studio: video production, photography, social content, a physical studio, event coverage. Goal of the site: show packages fast and get visitors to a quote. Brand is strictly black & white. The concept is a camera **viewfinder**: HUD chrome (REC, timecode, frame counter, exposure readout), an autofocus reticle that follows the cursor, lens-style rings, shutter/flash transitions.

7 pages, one shared shell: **Home · Video production · Social marketing · Events · Studio · Packages · Contact**. Video/Social/Events are grouped under a non-clickable “Services” heading in the menu.

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

**Intro (first load only, not on client-side page change, skipped when `?embed=1`)** — note: page background is always dark; there are no light zones.
Black full-screen. The logo mark draws itself in (see "Logo animation", 1.7s, stroke 6) centered at 72×80px; at 1.7s an **iris** opens (a circle with a 250vmax black box-shadow whose width/height animate 0→300vmax over 1.7s, ease mechanical). Hero text starts at 1.9s. Overlay removed at 3.5s.

**HUD (fixed, z 500, pointer-events none except buttons, white + difference blend)**
- 18×18 corner brackets at 16px from each corner (1px lines).
- A fixed dark scrim sits behind the top row on all sizes: `linear-gradient(180deg, rgba(12,12,12,.92) 0%, rgba(12,12,12,.7) 45%, transparent 100%)`, height 120px desktop / 96px mobile.
- Top row at 26px / 36px inset: left = logo mark (28×31 vector) + `/ PAGE NAME` label (desktop only); center = blinking 7px dot + `REC` + live timecode `HH:MM:SS:FF` (desktop only, 250ms tick); right = `Packages` (underlined; reads `Contact` on the Packages page) + `Menu ≡` (all sizes).
- Bottom-right (desktop): `FR 0000 / 1000` = scroll progress ×1000. Bottom corner brackets are desktop only.
- **Navigation = full-screen menu on all sizes** (no rail). `Menu ≡` opens a `#0c0c0c` overlay (fade .35s): rows Home · **Services** (heading, not clickable — under it three pill links Video production / Social marketing / Events) · Studio · Packages · Contact. Row = number + Cormorant title `clamp(30px,5.5vw,76px)` + hairline bottom; hover shifts padding-left 12px and lifts opacity .6→1; desktop shows a right-aligned hint per row (`You are here` for the current page). Bottom row: horizontal lockup logo + `Close ✕` pill. Clicking any item closes the menu, jumps to the top of the target page and plays a ~1s **page-transition stamp** (dark overlay, small logo draw-in). Esc closes.
- AF reticle (desktop only): 44×44 box made of four 10px corner brackets (1.5px), fixed, follows the cursor (offset −22,−22) with `transform .22s`. On hover of any CTA/card/nav item it **locks**: moves to the element's bounding box +8px padding (width/height animate .35s). Unlocks on mouseleave or scroll.
- Back-to-top (desktop): 44px round button, fixed right 20px bottom 60px, `rgba(12,12,12,.72)` + blur + `rgba(236,235,230,.4)` border, shows after 1 viewport of scroll.
- Range pill (after the visitor has changed anything in the builder; all pages except Packages and Contact): fixed bottom-center pill `Your range  $X – $Y  →` (paper background, ink text) linking to Contact. Bottom 28px desktop / 80px mobile.
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

### 2. Video production (`#video`)
- Spec strip under the hero: 4 hairline cells — Formats 6 · First cut 7–10 days · Crew 2–4 · From $899.
- 2-col intro ("Films that *sell* without looking like ads."); 6 hairline format cards with lens label + "From" price (Commercials $1,500 · Brand films $2,500 · Product $499 · Real estate $1,200 · Music videos $1,800 · Documentary on request); **The full production** 12-item checklist.
- **Video packages** (`#plans`): 3 cards from the catalog (Essential $899–1,200 · Growth $2,499–3,200 · Signature $6,000–8,500, per project) with bullet items; button "Add <plan> →" selects that plan in the builder state and navigates to Packages; a selected plan shows "In your package ✓" and a faint fill. Footer row links to the builder.
- Recent films work grid (6).

### 2b. Social marketing (`#social`)
- Horizontal 9:16 feed strip under the hero (8 tiles 190px / 150px mobile, autoplay when visible, scrollable).
- 2-col intro ("One shoot day. A *month* of content."); 6 cards (Content days … Paid support); **Vertical first** block with stats 8 / 3 / 48h + three 9:16 tiles.
- **Monthly plans** (`#plans`): Basic Presence $499 · Pro Essentials $1,990 · Elite Cinematic $4,000 (/ mo) — same card component as above.

### 2c. Events (`#events`)
- Live strip under the hero: blinking dot + "Live · 2 operators · 48h recap · Same-week verticals · GTA travel included".
- 2-col intro ("Filmed live. Posted *while* it still matters."); 6 coverage cards with prices; **Event day** 5-column timeline.
- **Coverage packages** (`#plans`): Launch $700–900 · Corporate $1,200–1,800 · Tournament $900–2,400 (per event).
- From the floor work grid (6).

### 3. Studio
- 2-col intro ("Book the room, *keep* the crew." + paragraph).
- Gallery: 4-col grid (2-col mobile), gap 16, iris reveal, hover scale 1.04: 16:10 span 2 · 4:5 · 4:5 · 4:5 · 16:10 span 3 (mobile: wide tiles span full row).
- **Kit list**: 2-col (label + H2 "Kit *list*" + paragraph | 6 numbered rows: Cinema bodies, Lighting, Sound, Sets, Client space, Crew).
- **Studio rates** (`#rates`): header + label `Extra time $100 / hr`; 4 hairline rows (`01 Half day in studio $450`, `02 Full day in studio $850`, `03 Podcast session $350`, `04 Portrait session $250`), grid `90px | 1fr | auto`, hover shifts padding-left 14px. Each row is a button “NN · Add →” that selects that studio plan in the builder and navigates to Packages.

### 4. Packages — per-service builder + 3-step send (`#packages`)
Intro 2-col ("Build *exactly* what you need."). Then a **3-step bar** (Build · Details · Brief; completed steps clickable) and one of four states:

**Step 1 · Build** — grid `1.4fr | .7fr` (stacked mobile). Left: one hairline card per service (Video production 24mm · Social marketing 35mm · Events 50mm · Studio 85mm). Card header = 22px checkbox + service name + right-aligned running sum ("$2,290 – $2,890 / mo" or "Not included"). When checked the card expands (fade .35s): plan tiles (auto-fit min 150px; selected = paper fill/ink text) + option chips (pill; selected = paper/ink) + include note + "Full details →" link to the service page. Right, sticky top 110px: **Your package** panel (mark icon + label), one row per active service (service · plan, add-ons line, range), total **Estimated range** in Cormorant clamp(40,4.4vw,72), unit note ("for social marketing" / "2 services · mixed billing"), **3-month contract · 10% off** toggle (38×22 pill switch, multiplies total by .9), note, button "Continue — your details →" (disabled copy "Pick at least one service" when nothing is on).

Catalog (all CAD; lo–hi used for the range):
- Video (project): Essential 899–1200 · Growth 2499–3200 · Signature 6000–8500. Options: Drone 300–600 · Second operator 250 · VFX / motion titles 150–600 · Licensed track 80–250 · Rush 24h +25% (percentage of plan).
- Social (/ mo): Basic Presence 499 · Pro Essentials 1990 · Elite Cinematic 4000. Options: +4 reels 700–900 · +10 photos 300–400 · Community replies 250 · Paid-social cuts 300–500 · Subtitles extra language 40–120.
- Events (event): Launch 700–900 · Corporate 1200–1800 · Tournament 900–2400. Options: Same-week verticals 300 · Dedicated photographer 350–450 · Live stream 500–900 · Drone 300–600 · Outside GTA 120–400.
- Studio (session): Portrait 250 · Half day 450 · Podcast 350 · Full day 850. Options: Extra hour 100 · Stylist 250–350 · +10 retouched 200–250 · Second operator 250.
Defaults: Social on with Pro Essentials; others off. State is global — service pages, the range pill, and the send flow all read it.

**Step 2 · Details** — hairline card: Name, Email, Phone, Business or brand (underline inputs, 2-col desktop), Industry chips (single-select: Social / creator, Real estate, Restaurant, Retail, Construction, Fashion, Family), **Preferred contact** chips (WhatsApp default / Phone call / Email). Soft validation: name + valid email required, error line under the fields. "← Back to the builder" / "Next — the brief →". Right (below on mobile): compact sticky summary with "Edit package".

**Step 3 · Brief** — Start date, Deadline or event date, Location, Budget comfort (optional), textarea "What is the content for?", textarea "Anything else — references, links, must-haves". "← Back" / "Send the request →".

**Sent** — hairline card with drawing mark + "Request logged · ZF-YYMMDD-NNN", italic H3 "Thanks, <first name> — we'll come back within two working days.", note naming the chosen contact channel and email; buttons "Build another package" / "Back to home". Right column: full echo of what was sent — services/plans/add-ons/range + every non-empty field. Submission is simulated in the prototype; wire to email/CRM in production.

Below all states: **Add-ons** list and **Common questions** accordion (unchanged). The range pill and the bottom "Get a quote" band are hidden on this page.

### 5. Contact (`#contact`)
- No form. 2-col (stacked mobile). Left: big hairline rows in Cormorant clamp(24–52px): **Call** +1 647-839-1491 (tel:) · **Email** Zeusframess@gmail.com (mailto:) · **WhatsApp** "Message us ↗" (wa.me) · **Studio** address · **Hours** Mon–Sat 9:00–19:00; hover shifts padding-left 12px. Then **Follow** pills: Instagram @zeusframes.inc · TikTok · YouTube · LinkedIn (last three URLs are placeholders — confirm). Right: 4:5 image + "Open in Maps ↗".
- Hero: "Say hello. / We're quick."; primary CTA becomes "Build a package" → Packages; secondary "WhatsApp us".

---

## Logo

Vector mark reconstructed from the client PNG (pixel IoU 96.6%). `assets/logo-mark.svg` = final static mark (viewBox `0 0 485 541`, single `fill-rule="evenodd"` path). `assets/logo-paths.json` = the 5 sub-paths (`hex` outer rounded hexagon, `tri` central inverted triangle cut-out, `cap` top cut-out, `kl`/`kr` side cut-outs) used for the draw-in.

**Logo draw-in animation** (duration D). Placements: intro iris (1.7s) · page-transition stamp (1.1s) · HUD mark (static) · lens centre on Home (static) · full-screen “mark stage” on Home (6s, with shutter flash at 70%) · inside the “How it runs” heading and the “Get a quote” band (2.6s, plays when scrolled into view) · lightbox header (1.4s) · Your-package panel icon (static) · footer above the lockup (3s, on reveal) · sent state (2.4s).
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
`page`, `mob`, `intro`, `navFlash`, `tc` (timecode), `lens`, `wh`, `lb`, `shot`, `menu`, `faq`, `brandSeen`, `touched`, `contract`, `cfg` ({video|social|events|studio: {on, plan, opts{}}} — the single source of truth for the package), `q` (1–3), `qSent`, `qErr`, `sentRef`, `form` (name, email, phone, brand, ind, via, start, deadline, location, budget, goal, notes).

## Contact data
+1 647-839-1491 · Zeusframess@gmail.com · 180 Shaughnessy Blvd, North York, ON M2J 1K3 · Mon–Sat 9:00–19:00 · instagram.com/zeusframes.inc

## Files in this bundle
- `Zeusframes Site.dc.html` — full desktop/mobile site (source of truth; template + logic class inside)
- `Zeusframes Mobile.dc.html` + `ios-frame.jsx` — phone showcase (embeds the site at 402px)
- `Zeusframes Logo Animation.dc.html` — isolated logo animation with replay
- `support.js` — prototype runtime (reference only, do not ship)
- `assets/` — logo SVG, path JSON, PNG lockups
