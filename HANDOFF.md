# ZeusFrames Studio — website handoff (v2)

Prototype of the full site for **ZeusFrames**, a boutique photo + video studio in Stouffville, ON. Theme: "Viewfinder" — always-dark (#0c0c0c / #ecebe6), Cormorant Garamond display + DM Mono UI, hairline grids, camera-HUD chrome, logo draw-in animations. Content, packages and pricing follow the two client PDFs in `source/`.

## Files
- `Zeusframes Site v2.dc.html` — desktop/responsive site, 8 pages in one file (client-side routing via `#hash`).
- `Zeusframes Mobile v2.dc.html` — phone-frame gallery that iframes each page of the site at 390px (`?embed=1#page` skips the intro).
- `Zeusframes Logo Animation.dc.html` — the logo draw-in sequence in isolation (vector fitted 96.6% to the source PNG).
- `support.js`, `ios-frame.jsx` — runtime + phone frame (required to open the .dc.html files).
- `assets/` — logo marks (SVG path + PNG lockups).
- `source/` — client blueprint + packages PDFs (the source of truth for copy and prices).

Open any `.dc.html` directly in a browser (same folder as `support.js`).

## Page map (hash → page)
| hash | page | key sections |
|---|---|---|
| `#home` | Home | Hero (Toronto aerial, timecode HUD) → Recent stories (6, "View full portfolio") → What we make (4 lens rows) → Motherhood & Family Journeys teaser ($900 / $1,280 / $2,050) → **Words from our clients** (2 sample quotes) → How it runs (5 steps) → About → CTA band |
| `#video` | Motherhood & Family | Spec strip → Approach → 6 session cards with photo (Maternity $450 · Newborn $550 · Family $450 · Kids $350 · Mini $199/slot · ArtFilm +$300) → What every session includes → **Single sessions** (plan cards, Book → Contact) → **ArtFilm video band** → **Journey planner** (`#journeys`) → Add-ons → **FAQ** (`#faq`, 6 Q&A accordion) → Recent chapters |
| `#social` | Fashion & Branding | 9:16 feed strip → Approach → 6 cards → Creator content day block → Packages (Editorial $650 · Creator Day $850 · Brand Story $1,200; first 10 bookings −10%) → add-ons |
| `#events` | Commercial & Music Video | Spec strip → Approach → 6 offer cards → How a project runs (timeline) → Starting points (Content $950 · Brand Film $2,500 · Music Video $2,800) → Recent projects |
| `#studio` | Studio Rental | Approach → What's in the room (6) → Rental rates (space $70/h · $260 · $480; +gear $90/h · $320 · $600; 2h min) → Request → Contact |
| `#portfolio` | Portfolio | Filter chips with counts (All · Motherhood · Family & Kids · Fashion & Branding · Video art · Commercial) → dense 4-col grid (1×1 / 2×1 / 1×2 / 2×2 tiles; hover plays, click opens lightbox with ← →) → per-filter "About <service> →" link → CTA |
| `#about` | About | Story → The studio (4 roles) → Our values (4) |
| `#contact` | Contact | **Inquiry form** (Name · Email · Phone · Service type dropdown · Preferred date · Message) + "Selected" box when arriving from a Book/Plan button → sent state (ref ZF-YYMMDD-NNN) · contact details, Maps, Instagram |

Removed vs. v1: Experience & Pricing page, per-service multi-step "package builder", 3-step brief. Every "Book" / "Plan this journey" / page-end CTA goes to Contact with the service pre-filled (mirrors the PDF's `/contact?service=` pattern).

## Pricing model (all CAD + HST, "Starting at")
- Motherhood & Family sessions as above; add-ons: extra image $20 · 10 images $150 · reel $200 · 8×10 $25 · 12×18 $45 · photo book from $250.
- **Journey bundles** (Motherhood page): A Bump to Baby $900 (value $1,000) · B Bump, Baby & Family $1,280 ($1,450) · C Legacy ArtFilm Journey $2,050 ($2,350). Payment options: per session (value price) · two installments 50/50 (bundle price) · pay in full (bundle −5%). Planner shows live total + "You save".
- Fashion add-ons: image $25 · reel $150 · hour $200. Commercial add-ons: extra day from $1,200 · social cut $200 · scriptwriting $300–500.
- Policies: 50% retainer, balance before shoot day, reschedule ≥48h, retainers non-refundable but transferable.

## State (logic class)
`page`, `mob` (<760px), `intro`, `navFlash`, `tc`, `lens`, `wh`, `lb` (lightbox index, ← → keys), `shot`, `menu`, `faq`, `brandSeen`, `touched`, `rangeHidden`, `cfg` (per-service {on, plan, opts}), `journey` (0–2), `pay` ('per'|'two'|'full'), `pf` (portfolio filter), `selFromCfg`, `selJourney`, `qSent`, `qErr`, `sentRef`, `form` {name, email, phone, svc, start, notes}.

## Media
All video/photo are Pexels/Unsplash placeholders, grayscale-filtered; replace with ZeusFrames footage. Grid videos lazy-load via `data-lazy`; hero uses `data-auto`. Console "aborted preload" errors are expected with placeholder video.

## SEO notes to implement in production (from the blueprint)
One primary keyword per page (e.g. "maternity and newborn photographer in Stouffville"); Stouffville/Toronto/GTA in `<title>`, meta description, H1 and first paragraph; descriptive image filenames + alt text with subject + location; internal links service ↔ portfolio ↔ contact; section anchors `#journeys`, `#faq`.

## Open items
- Replace sample testimonials with real reviews (Google).
- Confirm TikTok/YouTube/LinkedIn URLs (Instagram is real: @zeusframes.inc).
- Form submission is simulated — wire to email/CRM.
