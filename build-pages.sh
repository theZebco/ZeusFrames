#!/usr/bin/env bash
# Generates one folder per page (motherhood-family/, about/, ...) from index.html
# so GitHub Pages serves clean paths. Re-run after editing index.html.
# Asset URLs are resolved at runtime from the site root (see routeBase() in index.html),
# so the copies only need the runtime script path and a canonical link adjusted.
set -e
cd "$(dirname "$0")"
SITE_URL="https://thezebco.github.io/ZeusFrames"
SLUGS="motherhood-family fashion-branding commercial-video studio-rental portfolio about contact"
for s in $SLUGS; do
  mkdir -p "$s"
  sed -E "s#src=\"\./support\.js\"#src=\"../support.js\"#; s#<link rel=\"canonical\" href=\"[^\"]*\">#<link rel=\"canonical\" href=\"$SITE_URL/$s/\">#" index.html > "$s/index.html"
done
grep -q 'rel="canonical"' index.html || sed -i -E "s#<title>#<link rel=\"canonical\" href=\"$SITE_URL/\">\n<title>#" index.html
echo "built: $SLUGS"
