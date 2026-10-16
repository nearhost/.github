#!/bin/sh
# Renders assets/header.html once per README at twice its CSS size, each with
# its own install command and line beside it. Needs Google Chrome and a
# checkout of nearhost/landing with dependencies installed, for the fonts:
# $LANDING, by default ~/Code/nearhost/landing.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
landing="$(cd "${LANDING:-$HOME/Code/nearhost/landing}" && pwd)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

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
