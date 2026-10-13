# .github

The organisation profile for [Nearhost](https://nearhost.dev). GitHub shows `profile/README.md` on the organisation's page.

## Layout

- `profile/README.md` is the profile text. Keep it in step with the landing page at nearhost.dev.
- `profile/header.png` is the header graphic.
- `assets/header.html` is the source for the header, and `assets/render.sh` renders it.

## Rendering the header

The header uses the site's fonts, which it loads from a sibling checkout of `nearhost/landing`:

    ~/Code/nearhost/landing    with npm install run
    ~/Code/nearhost/github     this repository

Then:

    sh assets/render.sh

It needs Google Chrome. Set `CHROME` to the binary's path if it is not in the default macOS location.

## Licence

MIT. See [LICENSE](LICENSE).
