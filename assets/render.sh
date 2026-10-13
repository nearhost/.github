#!/bin/sh
# Renders assets/header.html to profile/header.png at twice its CSS size.
# Needs Google Chrome and a sibling checkout of nearhost/landing with dependencies installed.
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
profile="$(mktemp -d)"
trap 'rm -rf "$profile"' EXIT
"$chrome" --headless=new --disable-gpu --hide-scrollbars \
  --user-data-dir="$profile" \
  --force-device-scale-factor=2 --window-size=1280,460 \
  --default-background-color=00000000 \
  --screenshot="$here/profile/header.png" "file://$here/assets/header.html" >/dev/null 2>&1
echo "wrote $here/profile/header.png"
