# Security policy

## Reporting a vulnerability

Report a vulnerability privately. Do not open a public issue, pull request or discussion for it.

Open the repository the problem affects, choose the Security tab, and select "Report a vulnerability". If you are not sure which repository, use [nearhost/nearhost](https://github.com/nearhost/nearhost/security/advisories/new). Only the maintainers can see the report.

Say what you found, which version it affects (`nearhost --version`), and how to reproduce it. A proof of concept helps. If the report is valid, we will agree a fix and a disclosure date with you and credit you in the advisory unless you prefer not to be named.

## Supported versions

Only the latest release is supported. Fixes ship as a new release, not as patches to older ones. Run `nearhost update` or reinstall to get it.

## What is in scope

Nearhost runs on your machine with some privileges, so these areas matter most:

- **The local certificate authority.** Its private key, where it is stored, how it is created and trusted, and anything that lets a certificate be issued for a name the user did not add.
- **sudo and the hosts file.** The commands Nearhost runs through `sudo`, and how it edits the managed block in `/etc/hosts`.
- **The agent API.** The Unix sockets that coding agents use to propose projects, including who can reach them and what they can make Nearhost do without the user's approval.
- **SSH transport.** How Nearhost starts `ssh`, forwards ports and reads `ssh_config`, including command or option injection through host names, paths or project config.
- **Install paths.** The install script at nearhost.dev, the Homebrew cask, the npm packages, release archives and their checksums, and `nearhost update`.

Presets and `.nearhostrc` files are also in scope where they could do more than propose routes and advice.

## Out of scope

- Problems that need an attacker who already has your user account or root on your machine.
- Vulnerabilities in the dev server you are serving through Nearhost, or in OpenSSH, your browser or your operating system.
- Reports from automated scanners with no demonstrated impact.
