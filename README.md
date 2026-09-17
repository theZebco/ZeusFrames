# Zeus Frames — Website prototype

Responsive marketing site for Zeus Frames (Toronto media studio), "Viewfinder" concept.
One page shell, eight sections switched by hash: `#home` `#video` `#social` `#events` `#studio` `#portfolio` `#about` `#contact`.
Single breakpoint at 760px: the same file renders the phone and desktop layouts.

- `index.html` — the site (desktop + mobile)
- `logo-animation.html` — isolated logo draw-in animation
- `support.js` — prototype runtime (loads React from a CDN)
- `assets/` — logo files, `img/` photos, `video/` web-optimized clips (1080p, no audio)
- `HANDOFF.md` — full design handoff notes (tokens, pages, motion)
- `source/` — client blueprint and packages PDFs (source of truth for copy and prices)
- `uploads/` — project brief PDF

## GitHub Pages

Deployed from `main`, folder `/ (root)`: https://thezebco.github.io/ZeusFrames/

The page must be served over HTTP; opening `index.html` from disk will not work.
