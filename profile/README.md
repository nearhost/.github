<a href="https://nearhost.dev"><img src="https://raw.githubusercontent.com/nearhost/.github/main/assets/header.png" alt="Nearhost. Run it anywhere. Open it here."></a>

**Nearhost** is a terminal app that opens a dev server running on one of your other machines at a local `https://myapp.test`, over the SSH config you already have. You install nothing on the server, and cookies, OAuth redirects, WebSockets and hot reload behave as they do on `localhost`.

```sh
curl -fsSL https://nearhost.dev/install.sh | sh
```

Or `brew install nearhost/tap/nearhost`, or `npx @nearhost/cli`. Then run `nearhost`, add a server, add a project, and press `o` to open it. The [quick start](https://nearhost.dev/docs/getting-started/introduction/) covers each step.

[Website](https://nearhost.dev) · [Docs](https://nearhost.dev/docs/getting-started/introduction/) · [Releases](https://github.com/nearhost/nearhost/releases) · [npm](https://www.npmjs.com/package/@nearhost/cli)

![The Nearhost terminal interface: servers and projects on the left, and the selected project's address, routes and request log on the right.](https://raw.githubusercontent.com/nearhost/.github/main/assets/tui.png)

## What you get

- **One address per project.** `https://myapp.test` today, tomorrow and after a reboot.
- **Real HTTPS, trusted once.** Secure cookies, OAuth callbacks and service workers behave as they do in production.
- **Hot reload and WebSockets.** They travel through the same SSH connection.
- **Nothing installed on the server.** No daemon, no open ports, and nothing written to your project unless you run `nearhost export`. If `ssh <host>` works, Nearhost works.
- **Any stack.** Nearhost routes ports. It reads `.env` to propose them, presets add Compose and Vite, and you can enter them by hand for anything else.
- **From your coding agent.** Claude Code, Codex and other agents can propose the project they work in, and you save it in Nearhost.
- **Nothing leaves your machines.** No relay, no account and no public URL.

## How it works

1. A local proxy answers `https://myapp.test` with a certificate from a certificate authority created on your machine.
2. OpenSSH carries the request to `localhost` on the remote machine, using your own `ssh_config`.
3. Dev server ports that pages load from `localhost` are forwarded to the same port number on your laptop.

Read more in the [docs](https://nearhost.dev/docs/).

## Repositories

| Repository | What it holds |
| --- | --- |
| [nearhost](https://github.com/nearhost/nearhost) | The terminal app and command line tool, written in Go, and the `@nearhost/cli` npm package. Issues and releases live here. |
| [presets](https://github.com/nearhost/presets) | The official preset registry: what Nearhost knows about Docker Compose, Laravel, Laravel Sail and Vite. |
| [landing](https://github.com/nearhost/landing) | The website and documentation at [nearhost.dev](https://nearhost.dev). |
| [homebrew-tap](https://github.com/nearhost/homebrew-tap) | The Homebrew cask. |

Nearhost is open source under the MIT licence, for macOS and Linux.
