<a href="https://nearhost.dev"><img src="https://raw.githubusercontent.com/nearhost/.github/main/assets/header.png" alt="Nearhost. Run it anywhere. Open it here."></a>

# .github

The organisation profile for [Nearhost](https://nearhost.dev), and the brand images every Nearhost README uses. GitHub shows `profile/README.md` on the organisation's page.

## Layout

- `profile/README.md` is the profile text. Keep it in step with the landing page at nearhost.dev.
- `assets/header.html` is the source for every README header. `assets/render.sh` renders one PNG per variant, each with its own install command:

  | Image | Command | Used by |
  | --- | --- | --- |
  | `header.png` | `curl -fsSL https://nearhost.dev/install.sh \| sh` | this profile, `nearhost`, `landing` |
  | `header-npm.png` | `npx @nearhost/cli` | `@nearhost/cli` on npmjs.com |
  | `header-brew.png` | `brew install nearhost/tap/nearhost` | `homebrew-tap` |
  | `header-presets.png` | `nearhost preset registry add nearhost/presets` | `presets` |

- `assets/tui.png` is the screenshot of the terminal interface, taken at twice its size from the working mock-up on nearhost.dev.

The READMEs load these images from `https://raw.githubusercontent.com/nearhost/.github/main/assets/`, so a change here reaches every one of them without a change there. Keep the file names stable.

## Rendering the headers

The headers use the site's fonts, which they load from a checkout of `nearhost/landing` with `npm install` run, at `~/Code/nearhost/landing` unless `LANDING` says otherwise. Then:

    sh assets/render.sh

It needs Google Chrome. Set `CHROME` to the binary's path if it is not in the default macOS location. To add a variant, add a `render` line at the end of the script.

## Licence

MIT. See [LICENSE](LICENSE).
