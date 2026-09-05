# Zeus Frames — Demos

Static demo pages for the Zeus Frames landing design.

- `index.html` — entry page linking to the demos
- `Zeusframes Landing.dc.html` — desktop landing (5 variants)
- `Zeusframes Mobile.dc.html` — mobile view inside iOS frames
- `support.js`, `ios-frame.jsx` — runtime and device-frame component
- `uploads/` — project brief PDF

## GitHub Pages

Settings → Pages → Source: **Deploy from a branch**, branch `main`, folder `/ (root)`.
The pages must be served over HTTP (they fetch `ios-frame.jsx` and load React from a CDN), so opening the files directly from disk will not work.
