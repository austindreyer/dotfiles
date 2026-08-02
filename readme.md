0;9u# dotfiles

Personal config for Claude Code, Neovim (LazyVim), and Kitty, kept in one repo so a new machine can be set up in a couple of minutes instead of from scratch.

## What's in here

```
dotfiles/
├── claude/       # Claude Code global config (CLAUDE.md and related files)
├── nvim/         # Neovim config (LazyVim-based)
├── kitty/        # Kitty terminal config
└── install.sh    # Bootstrap script for new machines
```

- **claude/** — the global `CLAUDE.md` Claude Code loads on every project, plus any supporting files it imports. Pointed to via the `CLAUDE_CONFIG_DIR` environment variable rather than the default `~/.claude`, so it can live in this repo. `claude/tasks/` is gitignored — that's runtime session state, not config.
- **nvim/** — a LazyVim setup configured as an IDE-style layout: file tree (`neo-tree`) on the left, buffer in the main pane, integrated terminal (`<C-/>`) toggleable at the bottom. Includes the `lang.docker`, `lang.markdown` extras and a custom linter override so `markdownlint-cli2` always reads `~/.markdownlint.json` regardless of which project directory you're in.
- **kitty/** — terminal emulator config.
- **install.sh** — installs missing dependencies via Homebrew (kitty, neovim, node, gh), symlinks `nvim/` and `kitty/` into `~/.config/`, and adds the required `PATH`/`CLAUDE_CONFIG_DIR` exports to `~/.zshrc`. Safe to re-run — it skips anything already in place.

## How the configs actually get used

Nothing in `~/.config/nvim` or `~/.config/kitty` is a real file — both are symlinks pointing back into this repo:

```
~/.config/nvim  -> ~/dotfiles/nvim
~/.config/kitty -> ~/dotfiles/kitty
```

So editing a config file in either location edits the same file that's tracked in git. There's no separate "live" version to keep in sync.

## Setting up a new machine

```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
source ~/.zshrc
```

Then open `nvim` once and let `lazy.nvim` install its plugins on first launch.

## After making changes

Since the configs are symlinked, edits made through Neovim or by hand under `~/.config/nvim` or `~/.config/kitty` are already inside the repo — just commit as usual:

```bash
cd ~/dotfiles
git add .
git commit -m "describe the change"
git push
```

## Notes / gotchas

- `~/.markdownlint.json` (global markdownlint rule overrides) is **not** part of this repo — it's a plain home-directory file, separate from the nvim config. Worth adding here later if you want it to travel with the rest of the setup.
- `markdownlint-cli2`'s config search only looks at the directory it's run from and below — it does not walk up to ancestor directories. The nvim linter override in `nvim/lua/plugins/lint.lua` works around this by always pointing it at `~/.markdownlint.json` explicitly.
- If a fresh `nvim` launch shows `⚠` PATH warnings, re-check that `install.sh` actually updated `.zshrc` and that you `source`d it (or opened a new terminal).

