# dotfiles

Personal config for Claude Code, ccstatusline, herdr, Neovim (LazyVim), and Kitty, kept in one repo so a new machine can be set up in a couple of minutes instead of from scratch.

## What's in here

```
dotfiles/
├── claude/       # Claude Code global config (CLAUDE.md, settings.json, hooks)
├── ccstatusline/ # Claude Code status line layout (tokens, context, git)
├── herdr/        # herdr terminal workspace config
├── nvim/         # Neovim config (LazyVim-based)
└── kitty/        # Kitty terminal config
```

- **claude/**: the global `CLAUDE.md` Claude Code loads on every project, plus `settings.json` and `hooks/`. Pointed to via the `CLAUDE_CONFIG_DIR` environment variable rather than the default `~/.claude`, so it can live in this repo. Because Claude writes all its runtime state (sessions, history, caches, daemon files) into this same directory, `claude/.gitignore` is an **allowlist**: everything is ignored except `CLAUDE.md`, `settings.json` and `hooks/`. To track a new config file, add a `!` line for it there.
- **ccstatusline/**: layout for [ccstatusline](https://github.com/sirmalloc/ccstatusline), the Claude Code status line. `claude/settings.json` runs it via `npx -y ccstatusline@2.2.34` (pinned so npx doesn't hit the registry on every turn; bump the version there to upgrade). Edit the layout interactively with `npx -y ccstatusline@2.2.34`; it saves to `~/.config/ccstatusline/settings.json`, which is a symlink into this repo.
- **herdr/**: config for [herdr](https://herdr.dev), a terminal multiplexer for AI coding agents. Only `config.toml` is tracked; `herdr/.gitignore` is an allowlist because herdr installs plugin checkouts and state under `plugins/` and `plugins.json` here.
- **nvim/**: a LazyVim setup configured as an IDE-style layout: file tree (`neo-tree`) on the left, buffer in the main pane, integrated terminal (`<C-/>`) toggleable at the bottom. Includes the `lang.docker` and `lang.markdown` extras, with markdownlint diagnostics disabled in `nvim/lua/plugins/markdown.lua`.
- **kitty/**: terminal emulator config.

## How the configs actually get used

Nothing in `~/.config/nvim`, `~/.config/kitty`, `~/.config/herdr` or `~/.config/ccstatusline` is a real file. They are symlinks pointing back into this repo:

```
~/.config/nvim  -> ~/dotfiles/nvim
~/.config/kitty -> ~/dotfiles/kitty
~/.config/herdr -> ~/dotfiles/herdr
~/.config/ccstatusline -> ~/dotfiles/ccstatusline
```

So editing a config file in either location edits the same file that's tracked in git. There's no separate "live" version to keep in sync.

## Setting up a new machine

Run these steps in order. Later steps depend on earlier ones (the Rust plugins need `cargo`, and the quota plugin needs both the plugin build and the `CLAUDE_SETTINGS_FILE` export).

### 1. Clone, install, symlink

```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
brew install kitty neovim node gh herdr rustup
ln -s ~/dotfiles/nvim  ~/.config/nvim
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/herdr ~/.config/herdr
ln -s ~/dotfiles/ccstatusline ~/.config/ccstatusline
```

### 2. Shell environment

```bash
cat >> ~/.zshrc <<'EOF'
export CLAUDE_CONFIG_DIR="$HOME/dotfiles/claude"
export CLAUDE_SETTINGS_FILE="$HOME/.config/herdr-agent-quota/claude-settings.json"
claude() {
  if [ -f "$CLAUDE_SETTINGS_FILE" ]; then
    command claude --settings "$CLAUDE_SETTINGS_FILE" "$@"
  else
    command claude "$@"
  fi
}
export PATH="/opt/homebrew/opt/rustup/bin:$HOME/.cargo/bin:$PATH"
EOF
source ~/.zshrc
rustup default stable
```

- `CLAUDE_CONFIG_DIR` makes Claude Code use `~/dotfiles/claude` instead of `~/.claude`.
- `CLAUDE_SETTINGS_FILE` points at a per-machine, untracked settings file that herdr-agent-quota (step 5) edits instead of the tracked `claude/settings.json`. The `claude` function loads it with `--settings`, which Claude applies above the user settings, so the quota status line wraps ccstatusline on this machine while the committed file stays portable. Without the file, `claude` runs normally.
- The `PATH` line puts `cargo` on PATH for the two Rust plugins in step 4.

### 3. Neovim and the Claude status line

Open `nvim` once and let `lazy.nvim` install its plugins on first launch.

The Claude Code status line (ccstatusline) needs nothing extra: `claude/settings.json` runs it through `npx`, and its layout comes from the symlink made in step 1. Start `claude` and send one message to confirm the footer shows model, context and git info.

### 4. herdr integration and plugins

Start herdr with `herdr` from a normal kitty tab (not from inside a herdr pane) so the server inherits the step 2 environment. The prefix is `ctrl+b`; `ctrl+b ?` shows all bindings. After editing `herdr/config.toml`, run `herdr server reload-config`.

Re-run the Claude Code integration on each machine. The hook entry it writes into `claude/settings.json` uses an absolute path, so this rewrites it for the local home directory:

```bash
herdr integration install claude
herdr integration status        # claude should show "current"
```

Plugins are not tracked (their checkouts hold machine-specific paths). Reinstall them at the pinned versions below. Plugins run unsandboxed as your user, so read a plugin's `herdr-plugin.toml` before bumping its ref. The last two compile with Rust on install.

```bash
herdr plugin install persiyanov/herdr-reviewr --ref v0.52.2          # review agent diffs beside the chat
herdr plugin install kryptamine/herdr-auto-title --ref v0.23.1       # automatic tab titles
herdr plugin install ntindle/herdr-resurrect --ref dab5bed632ccb28b480ae1bd601b4f60a41f66f1  # restore sessions after crash/reboot
herdr plugin install thanhdat77/herdr-navigator --ref v0.3.6         # fuzzy jump to workspaces/agents/projects (needs Rust)
herdr plugin install levi-qiao/herdr-agent-usage --ref v1.6.2        # installs as herdr-agent-quota: Claude 5h/7d quota in the sidebar (needs Rust)
herdr plugin list
```

### 5. Connect herdr-agent-quota to Claude (optional, per machine)

Installing the plugin does not connect it to Claude. Its configure step wraps the status line in the file named by `CLAUDE_SETTINGS_FILE`: Claude still runs ccstatusline, and the plugin silently collects the 5h/7d quota for the herdr sidebar. It also updates `herdr/config.toml` with its sidebar rows. Because the wrapper holds absolute paths to this machine's plugin build, it goes in the untracked file from step 2, never in `claude/settings.json`.

The plugin wraps whatever status line the file already has, so seed it with the ccstatusline command first. Run this from a shell that has the step 2 exports (open a new terminal after step 2):

```bash
mkdir -p "$(dirname "$CLAUDE_SETTINGS_FILE")"
cat > "$CLAUDE_SETTINGS_FILE" <<'EOF'
{"statusLine": {"type": "command", "command": "npx -y ccstatusline@2.2.34", "padding": 0}}
EOF
QUOTA_BIN=$(ls ~/.config/herdr/plugins/github-installations/herdr-agent-quota-*/*/checkout/target/release/herdr-agent-quota | head -1)
HERDR_PLUGIN_STATE_DIR=~/.local/state/herdr/plugins/herdr-agent-quota "$QUOTA_BIN" configure --check --agent claude   # preview only
HERDR_PLUGIN_STATE_DIR=~/.local/state/herdr/plugins/herdr-agent-quota "$QUOTA_BIN" configure --apply --agent claude
herdr server reload-config
git -C ~/dotfiles diff herdr/config.toml     # sidebar rows it wrote
```

Then restart any open Claude panes (so the `claude` function from step 2 loads the file) and send one turn in each so the status line reports quota. `git status` must not show `claude/settings.json` as modified.

To undo, run the same command with `--uninstall --agent claude`, then `herdr server reload-config`. It restores the plain ccstatusline command in the untracked file.

### 6. Claude plugins

`claude/settings.json` declares the marketplace (`austin-plugins`, from `austindreyer/claude-marketplace`) and the enabled plugins. On first launch, Claude offers to install them; accept, then restart. If it doesn't prompt, run `/plugin marketplace add austindreyer/claude-marketplace` and `/plugin install superpowers@austin-plugins`, `/plugin install adversarial-reviewer@austin-plugins`, and `/plugin install thinking-red-team@austin-plugins`. Plugin files live under `claude/plugins/`, which is gitignored. To bump or add a plugin, edit the marketplace repo (see its README), not this one.

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
