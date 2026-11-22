# dotfiles

Personal config for Claude Code, herdr, Neovim (LazyVim), and Kitty, kept in one repo so a new machine can be set up in a couple of minutes instead of from scratch.

## What's in here

```
dotfiles/
├── claude/       # Claude Code global config (CLAUDE.md, settings.json, hooks)
├── herdr/        # herdr terminal workspace config
├── nvim/         # Neovim config (LazyVim-based)
└── kitty/        # Kitty terminal config
```

- **claude/**: the global `CLAUDE.md` Claude Code loads on every project, plus `settings.json` and `hooks/`. Pointed to via the `CLAUDE_CONFIG_DIR` environment variable rather than the default `~/.claude`, so it can live in this repo. Because Claude writes all its runtime state (sessions, history, caches, daemon files) into this same directory, `claude/.gitignore` is an **allowlist**: everything is ignored except `CLAUDE.md`, `settings.json` and `hooks/`. To track a new config file, add a `!` line for it there.
- **herdr/**: config for [herdr](https://herdr.dev), a terminal multiplexer for AI coding agents. Only `config.toml` is tracked; `herdr/.gitignore` is an allowlist because herdr installs plugin checkouts and state under `plugins/` and `plugins.json` here.
- **nvim/**: a LazyVim setup configured as an IDE-style layout: file tree (`neo-tree`) on the left, buffer in the main pane, integrated terminal (`<C-/>`) toggleable at the bottom. Includes the `lang.docker` and `lang.markdown` extras, with markdownlint diagnostics disabled in `nvim/lua/plugins/markdown.lua`.
- **kitty/**: terminal emulator config.

## How the configs actually get used

Nothing in `~/.config/nvim`, `~/.config/kitty` or `~/.config/herdr` is a real file. They are symlinks pointing back into this repo:

```
~/.config/nvim  -> ~/dotfiles/nvim
~/.config/kitty -> ~/dotfiles/kitty
~/.config/herdr -> ~/dotfiles/herdr
```

So editing a config file in either location edits the same file that's tracked in git. There's no separate "live" version to keep in sync.

## Setting up a new machine

```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
brew install kitty neovim node gh herdr
ln -s ~/dotfiles/nvim  ~/.config/nvim
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/herdr ~/.config/herdr
echo 'export CLAUDE_CONFIG_DIR="$HOME/dotfiles/claude"' >> ~/.zshrc
source ~/.zshrc
```

Then open `nvim` once and let `lazy.nvim` install its plugins on first launch.

### herdr

Re-run the Claude Code integration on each machine. The hook entry it writes into `claude/settings.json` uses an absolute path, so this rewrites it for the local home directory:

```bash
herdr integration install claude
herdr integration status        # claude should show "current"
```

Plugins are not tracked (their checkouts hold machine-specific paths). Reinstall them at the pinned versions below. Plugins run unsandboxed as your user, so read a plugin's `herdr-plugin.toml` before bumping its ref.

```bash
herdr plugin install persiyanov/herdr-reviewr --ref v0.52.2          # review agent diffs beside the chat
herdr plugin install kryptamine/herdr-auto-title --ref v0.23.1       # automatic tab titles
herdr plugin install ntindle/herdr-resurrect --ref dab5bed632ccb28b480ae1bd601b4f60a41f66f1  # restore sessions after crash/reboot
herdr plugin list
```

Start herdr with `herdr` from a normal kitty tab (not from inside a herdr pane). The prefix is `ctrl+b`; `ctrl+b ?` shows all bindings. After editing `herdr/config.toml`, run `herdr server reload-config`.

## After making changes

Since the configs are symlinked, edits made through Neovim or by hand under `~/.config/...` are already inside the repo, so just commit as usual:

```bash
cd ~/dotfiles
git add .
git commit -m "describe the change"
git push
```

## Notes / gotchas

- `~/.markdownlint.json` (global markdownlint rule overrides) is **not** part of this repo. It's a plain home-directory file, separate from the nvim config. Worth adding here later if you want it to travel with the rest of the setup.
- If a fresh `nvim` launch shows `⚠` PATH warnings, re-check that `.zshrc` has the exports above and that you `source`d it (or opened a new terminal).
- Inside herdr, pane navigation is `ctrl+b h/j/k/l`. The kitty `ctrl+h/j/k/l` handoff to nvim only knows about kitty splits and nvim splits, not herdr panes, so it's simplest to use kitty for tabs only and let herdr do the splitting.
