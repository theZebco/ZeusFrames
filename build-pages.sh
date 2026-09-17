#!/usr/bin/env bash
# Generates one folder per page (motherhood-family/, packages/, ...) from index.html
# so GitHub Pages serves clean paths. Re-run after editing index.html.
#
# Asset URLs and the canonical link are resolved at runtime (routeBase() and the
# designer's applySeo()), so each copy only needs the runtime script path fixed.
set -euo pipefail
cd "$(dirname "$0")"
SLUGS="motherhood-family fashion-branding commercial-music-video studio-rental packages portfolio about contact"
ALIASES="commercial-video experience-pricing"   # old links kept alive; index.html maps them
for s in $SLUGS $ALIASES; do
  mkdir -p "$s"
  sed -E 's#src="\./support\.js"#src="../support.js"#' index.html > "$s/index.html"
done
# drop folders from earlier slug sets
for d in video social events services; do [ -d "$d" ] && rm -rf "$d"; done
echo "built: $SLUGS (aliases: $ALIASES)"
