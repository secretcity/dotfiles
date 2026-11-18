# secretcity dotfiles

My macOS dev environment: fish, Ghostty, herdr, Starship, Git and Claude Code, set up and kept current by one CLI, `dot`. Fork it, take what you like, make it yours.

**Stack:** fish · Ghostty · herdr · Starship · Git · Claude Code · Vite+ · Homebrew · GNU Stow

## Quick start

```bash
git clone https://github.com/secretcity/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dot init                # full setup
./dot init --skip-ssh     # same, without generating an SSH key
```

Restart the terminal, then check everything landed:

```bash
dot doctor
```

Before your first commit, set your own Git identity (see [Make it yours](#make-it-yours)). Mine isn't in here.

## How it works

- **`home/` mirrors `~`.** GNU Stow symlinks everything in it into your home folder. Edit the files under `home/`, never the live copies in `~/.config` - a restow replaces them.
- **`packages/bundle`** is the Brewfile: formulae, casks and taps.
- **`dot`** is a bash CLI that runs an ordered tool registry (`TOOL_REGISTRY` in `dot`). `dot init` installs from it and `dot doctor` checks against it.

```
.dotfiles/
├── dot                  # the CLI
├── home/                # stowed to ~
│   ├── .config/
│   │   ├── fish/        # shell: conf.d/ auto-sourced, functions/ lazy-loaded
│   │   ├── ghostty/     # terminal
│   │   ├── herdr/       # workspace, tab and pane manager
│   │   ├── git/
│   │   ├── starship.toml
│   │   └── ripgrep/
│   ├── .agents/skills/  # agent skills for Claude Code
│   ├── .claude/agents/  # Claude Code sub-agents
│   └── .local/bin/      # small scripts, including claude-statusline
├── packages/bundle      # Brewfile
├── LICENSE
└── THIRD-PARTY-NOTICES.md
```

## What `dot init` does

In order, and safe to re-run:

1. Installs Homebrew if it's missing
2. Installs everything in `packages/bundle`
3. Stows `home/` into `~`
4. Installs Bun
5. Installs the herdr plugins in `home/.config/herdr/plugins.txt` and herdr's Claude Code integration
6. Installs Vite+ (skipped if the Brewfile already provided `vp`)
7. Generates a GitHub SSH key (optional, `--skip-ssh`)
8. Sets fish as your default shell and installs the Fisher plugins

A failed package doesn't stop the run. It's recorded in `packages/failed_packages_*.txt`; retry with `dot retry-failed`.

## Commands

| Command | What it does |
|---|---|
| `dot init` | Full setup (above) |
| `dot update` | Pull, `brew update` and upgrade, restow, sync herdr plugins |
| `dot doctor` | Health check: tools, symlinks, PATH, fish |
| `dot stow` | Re-create the symlinks after editing `home/` |
| `dot package add\|remove\|update\|list` | Manage the Brewfile |
| `dot check-packages` | Installed vs missing packages |
| `dot retry-failed` | Retry packages that failed during init |
| `dot gen-ssh-key` | Generate an ed25519 key and copy the public half |
| `dot benchmark-shell` | fish startup time |
| `dot completions` | fish completions for `dot` |
| `dot link` / `dot unlink` | Add or remove a global `dot` symlink |
| `dot help` | Overview; `dot <command> --help` for detail |

```bash
dot package add ripgrep          # formula (type detected)
dot package add raycast cask     # cask
dot package remove raycast
```

Work-only formulae go in `packages/bundle.work`, which is gitignored. If it exists, `dot init` offers to install it. Casks belong in the base bundle.

## Agent skills

`home/.agents/skills/` holds the skills I use with Claude Code. They stow to `~/.agents/skills/`, and `home/.claude/skills/` links the ones Claude Code loads. Most come from other people's projects and keep their licences - see [Credits](#credits).

Cloudflare's skills aren't copied here because they change weekly. Install them straight from [cloudflare/skills](https://github.com/cloudflare/skills), including `cf-cli` for Cloudflare's official `cf` CLI.

## Claude Code agents and status line

`home/.claude/agents/` has seven sub-agents, each pinned to a model for one kind of job:

| Agent | Model | Job |
|---|---|---|
| `scout` | Haiku | One read-only question, answered in 15 lines |
| `scribe` | Haiku | One mechanical write - docs, renames, formatting |
| `implementer` | Sonnet | Builds a change to a done-check and opens the PR, never merges |
| `reviewer` | Sonnet | Checks a PR it didn't write and posts a verification report |
| `ui-verifier` | Sonnet | Compares a preview with production, with screenshots |
| `designer` | Opus | Writes the design note before a risky change is built |
| `reviewer-adversarial` | Opus | Tries to break a risky PR first and commits its probes |

`claude-statusline` puts the model, context used, 5-hour rate limit, folder and branch under the prompt. It needs `jq` (in the Brewfile). Point Claude Code at it in `~/.claude/settings.json`;

```json
"statusLine": { "type": "command", "command": "~/.local/bin/claude-statusline" }
```

## Secrets

No secret values live in this repo, and none should. My pattern: a config names the secret and fetches it at the moment a tool needs it, with an absolute-path [Doppler](https://www.doppler.com/) command, so tokens never get exported into the shell or into agent subprocesses:

```bash
/opt/homebrew/bin/doppler secrets get SOME_API_KEY --plain --project <project> --config <config>
```

Use your own project and config, or your own secret manager. `fish/conf.d/secrets.fish` is gitignored as a safety net - don't put new secrets there.

## Make it yours

- **Git identity:** `home/.config/git/config` includes `~/.config/git/local`, which isn't tracked. Put your `[user]` name, email and signing key there.
- **Packages:** trim `packages/bundle` to what you use.
- **SSH:** `dot gen-ssh-key you@example.com`, then add the key to GitHub as both an authentication key and a signing key, since commit and tag signing is on.
- **Cloudflare One (WARP):** if Gateway TLS inspection is on, save the Gateway CA as `~/.local/share/cloudflare-warp-certs/Cloudflare_CA.pem` and `fish/conf.d/cloudflare-warp-certs.fish` points Node, curl, Git, Python and Cargo at it.

## Troubleshooting

- **`dot: command not found`** - run `source ~/.config/fish/config.fish`, or `./dot link` from the repo.
- **Broken symlinks** - `dot doctor`, then `dot stow`.
- **Stow conflicts** - stow won't overwrite a real file. Move it out of the way and run `dot stow` again.
- **Package failures** - `dot check-packages`, then `dot retry-failed`.

## Contributing

Issues and suggestions are welcome. This repo is published from my private one, so I'll port a good pull request across by hand rather than merging it here - you'll be credited in the commit.

## Credits

This started as a fork of [Dillon Mulroy's dotfiles](https://github.com/dmmulroy/.dotfiles) in October 2026. The `dot` CLI and a few scripts and skills are his work, used under the "feel free to fork and adapt" note in his README, and I've built on them since. Thanks Dillon.

Also drawn from:

| What | From | Licence |
|---|---|---|
| fish git abbreviations (installed by Fisher) | [jhillyerd/plugin-git](https://github.com/jhillyerd/plugin-git) | MIT |
| diagnosing-bugs, domain-modeling, grilling, prototype, tdd, writing-for-agents skills | [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock | MIT |
| frame-a-proposal, record-a-decision, review-a-design, write-a-postmortem, write-a-spec skills | [inkeep/open-knowledge-skills](https://github.com/inkeep/open-knowledge-skills) by Inkeep | MIT |
| write-discoverable-code skill | [modem-dev/skills](https://github.com/modem-dev/skills) by Modem | MIT |
| show-me skill | [humanlayer/skills](https://github.com/humanlayer/skills) by HumanLayer | MIT |
| herdr skill | [herdrdev/herdr](https://github.com/herdrdev/herdr) | Apache-2.0 |
| plannotator-tui skill | [plannotator/plannotator-tui](https://github.com/plannotator/plannotator-tui) by Michael Ramos | MIT |
| cua-driver skill | [trycua/cua](https://github.com/trycua/cua) by Cua AI | MIT |

Where I've changed a copied file, `THIRD-PARTY-NOTICES.md` says what changed and carries each upstream licence in full. If I've missed crediting your work, open an issue and I'll fix it.

And the tools these configs drive: [fish](https://fishshell.com), [Ghostty](https://ghostty.org), [herdr](https://github.com/herdrdev/herdr), [Starship](https://starship.rs), [GNU Stow](https://www.gnu.org/software/stow/) and [Homebrew](https://brew.sh).

## Licence

My own work here is [MIT](LICENSE): copy it, change it, ship it, just keep the copyright notice. Third-party files keep their own licences, listed in `THIRD-PARTY-NOTICES.md`.
