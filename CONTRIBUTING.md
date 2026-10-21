# Contributing

Thanks for helping with Nearhost. This guide applies to every public repository in the nearhost organisation unless a repository's own CONTRIBUTING.md or README says otherwise.

## Before you start

- For a bug, search the existing issues, then open one with the bug template. Include the output of `nearhost --version` and `nearhost doctor`.
- For a larger change, open an issue first so we can agree on the approach before you write it.
- Report security problems privately. See the [security policy](SECURITY.md).

## Pull requests

Open a pull request against `main`. Keep it to one change, and say in the description what it fixes and how you checked it.

Pull requests are squash merged, and the title becomes the commit message. Write the title as a [Conventional Commit](https://www.conventionalcommits.org/), in lower case and plain words, such as `feat: read ports from .env.local` or `fix: keep the hosts block when up fails`. Add a scope when it helps, as in `fix(vite): read quoted keys in the vite config`.

## Checks

Run the checks for the repository you are changing before you push. CI runs the same ones.

| Repository | Setup | Check |
| --- | --- | --- |
| [nearhost](https://github.com/nearhost/nearhost) | Git and the Go version in `go.mod` | `go test -race ./...` and `go vet ./...` |
| [landing](https://github.com/nearhost/landing) | `nvm use`, then `npm install` | `npm run verify` |
| [presets](https://github.com/nearhost/presets) | Git, Make and Go | `make check` |

The README of each repository describes how to build and run it.

When you run a development build of Nearhost, point it at a scratch config directory with `XDG_CONFIG_HOME` and use `--no-hosts` so it leaves your real config, certificate authority and `/etc/hosts` alone. The tests need no network, Docker or SSH server.

## What differs by repository

- **nearhost.** Releases are cut by [release-please](https://github.com/googleapis/release-please) from the commit messages on `main`, and GoReleaser attaches the binaries to each GitHub Release. This is why the title format matters.
- **landing.** Commit titles have no body. Prettier and ESLint run on staged files before each commit. Copy is plain text and labels are in sentence case.
- **presets.** Include fixtures with every preset change. Leave `index.yaml` alone: after a merge, CI opens a `chore: rebuild the index` pull request that publishes the change.

## Licence

Contributions are made under each repository's licence, which is MIT.
