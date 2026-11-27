#!/bin/sh
# Renders assets/header.html once per README at twice its CSS size, each with
# its own install command and line beside it. Needs Google Chrome and a
# checkout of nearhost/landing with dependencies installed, for the fonts, and
# built (npm run build) for tui.png: $LANDING, by default ~/Code/nearhost/landing.
# tui.png is cropped with sharp from that same checkout's node_modules.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
landing="$(cd "${LANDING:-$HOME/Code/nearhost/landing}" && pwd)"
mac_chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ -z "${CHROME:-}" ]; then
  if [ -x "$mac_chrome" ]; then CHROME="$mac_chrome"; else CHROME=google-chrome; fi
fi
chrome="$CHROME"
command -v node >/dev/null 2>&1 || { echo "render.sh needs node, to crop tui.png" >&2; exit 1; }
[ -d "$landing/node_modules/sharp" ] || { echo "render.sh needs sharp in $landing/node_modules (run npm install there)" >&2; exit 1; }
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
# screenshot one element from the command line, so take the whole page and crop
# to the demo frame, which crop.js measures from its border.
# astro re-launches itself, so the PID to stop is whatever listens on the port.
(cd "$landing" && npx astro preview --port 4399 >/dev/null 2>&1 &)
for _ in $(seq 1 30); do
  curl -sf http://localhost:4399/ >/dev/null 2>&1 && break
  sleep 1
done
preview="$(lsof -ti tcp:4399 -sTCP:LISTEN | head -n1)"
"$chrome" --headless=new --disable-gpu --hide-scrollbars \
  --user-data-dir="$work/profile-tui" \
  --force-device-scale-factor=2 --window-size=1280,2400 --virtual-time-budget=8000 \
  --screenshot="$work/page.png" http://localhost:4399/ >/dev/null 2>&1
node "$here/crop-frame.js" "$landing" "$work/page.png" "$here/tui.png"
echo "wrote $here/tui.png"
