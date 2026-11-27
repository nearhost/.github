#!/bin/sh
# Renders assets/header.html once per README at twice its CSS size, each with
# its own install command and line beside it. Needs Google Chrome and a
# checkout of nearhost/landing with dependencies installed, for the fonts, and
# built (npm run build) for tui.png: $LANDING, by default ~/Code/nearhost/landing.
# Also needs ImageMagick (magick) to crop tui.png.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
landing="$(cd "${LANDING:-$HOME/Code/nearhost/landing}" && pwd)"
mac_chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ -z "${CHROME:-}" ]; then
  if [ -x "$mac_chrome" ]; then CHROME="$mac_chrome"; else CHROME=google-chrome; fi
fi
chrome="$CHROME"
work="$(mktemp -d "${TMPDIR:-/tmp}/nearhost-render.XXXXXX")"
preview=""
cleanup() {
  [ -z "$preview" ] || kill "$preview" 2>/dev/null || true
  rm -rf "$work"
}
trap cleanup EXIT

render() { # render <output> <install command> <line beside it, HTML>
  sed -e "s#LANDING/#file://$landing/#g" -e "s#INSTALL#$2#" -e "s#SUB#$3#" "$here/header.html" > "$work/header.html"
  "$chrome" --headless=new --disable-gpu --hide-scrollbars \
    --user-data-dir="$work/profile" \
    --force-device-scale-factor=2 --window-size=1280,460 \
    --default-background-color=00000000 \
    --screenshot="$here/$1" "file://$work/header.html" >/dev/null 2>&1
  echo "wrote $here/$1"
}

dev='Your remote dev server at <code>https://myapp.test</code>'
render header.png 'curl -fsSL https://nearhost.dev/install.sh | sh' "$dev"
render header-npm.png 'npx @nearhost/cli' "$dev"
render header-brew.png 'brew install nearhost/tap/nearhost' "$dev"
render header-presets.png 'nearhost preset registry add nearhost/presets' 'The official preset registry'

# tui.png: the demo on the built landing page, at twice its size. Chrome cannot
# screenshot one element from the command line, so take the page and crop to the
# demo frame, found by the first border-coloured row down the right of the page, clear of the install box.
# astro re-launches itself, so the PID to stop is whatever listens on the port.
(cd "$landing" && npx astro preview --port 4399 >/dev/null 2>&1 &)
for _ in $(seq 1 30); do
  curl -sf http://localhost:4399/ >/dev/null 2>&1 && break
  sleep 1
done
preview="$(lsof -ti tcp:4399 -sTCP:LISTEN | head -n1)"
"$chrome" --headless=new --disable-gpu --hide-scrollbars \
  --user-data-dir="$work/profile-tui" \
  --force-device-scale-factor=2 --window-size=1280,1800 --virtual-time-budget=8000 \
  --screenshot="$work/page.png" http://localhost:4399/ >/dev/null 2>&1
top="$(magick "$work/page.png" -crop 1x1200+2400+1000 +repage txt:- | grep -m1 '#2F2A33' | sed 's/^0,\([0-9]*\):.*/\1/')"
[ -n "$top" ] || { echo "could not find the demo frame in the page" >&2; exit 1; }
magick "$work/page.png" -crop "2304x1598+128+$((top + 1000))" +repage -alpha off "$here/tui.png"
echo "wrote $here/tui.png"
