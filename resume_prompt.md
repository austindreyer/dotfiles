# Resume prompt (updated 2026-11-27)

## Goal
Finish the dotfiles/Claude tooling setup, then move on to home network security, Nora's phone, and the home secret manager.

## Current state
- Done: personal marketplace `austindreyer/claude-marketplace` (private, local clone `~/claude-marketplace`), name `austin-plugins`. Default branch is `main`; Claude reads from it, so changes must be promoted dev to main to take effect.
- Plugins in it: `superpowers` (pinned to `22f0b463e7a5e579904dd6211a520321035526f7`, v7.0.2) and `adversarial-reviewer` (single skill vendored from alirezarezvani/claude-skills at `ea7b5ab8da93bbba8880152d9ccb8c9979f12252`, v2.9.0, MIT; upstream only ships it inside a 32-skill plugin with a hook). Both installed and enabled in `claude/settings.json`.
- Done: dotfiles PRs #1 and #2 merged into `dev`. `dev-container` renamed to `dev` everywhere; `origin/dev-container` deleted. Model default is sonnet.
- Done: `thinking-red-team` vendored (tjboudreaux/cc-thinking-skills at `7b8fece345dfaa11773be7152ccd194589cb5437`, v1.0.0, MIT), installed and enabled. Promoted to marketplace `main`.
- Done: quota status line wrapper split out of tracked settings (dotfiles PR #4). `CLAUDE_SETTINGS_FILE` now points at untracked `~/.config/herdr-agent-quota/claude-settings.json`; a `claude()` function in `~/.zshrc` adds `--settings` for it. Verified: quota shows in the herdr agents panel. Backups of the pre-split files are in the session scratchpad (may be cleared).
- Local branch: dotfiles `dev` (up to date after PR #5 merge). All merged feature/chore branches deleted in both repos.
- Done: herdr quota rows, kitty splits and icon font, nvim terminal and markdown config committed in four groups (dotfiles PR #5). Working tree is clean; `resume_prompt.md` is now tracked in the repo.

## Next steps (in order)
1. Optional: search for Home Assistant skills. `thinking-red-team` is installed (user-invoked; authorized security review, exploit-path-or-drop rule) and ready for the network review.
2. Home network security review. Discovery needed first: router/firewall, VLANs, devices, what is exposed, how Home Assistant is hosted.
3. Set up Nora's phone with VPN and Home Assistant (depends on the network review for remote access design).
4. Finalize the home secret manager (current state and definition of done not yet discussed).

## Key decisions
- Own marketplace. Third-party plugins pinned by full `sha`; exception: a single skill that upstream only ships inside a larger plugin may be vendored under `plugins/<name>/` unmodified with LICENSE and upstream commit recorded.
- Model default is sonnet, never opus.
- Branches: work from `dev`; feature/fix/chore branches off `dev`; PRs to `dev`; promote to `main` only when asked. When the user explicitly asks, I create and merge PRs.
- Checking out `dev` with uncommitted files can fail; use `git fetch origin dev:dev` then checkout.
- herdr defaults: prefix `ctrl+b`; split right `v`, split down `-`, close pane `x`, new tab `c`, close tab `shift+x`, `?` lists bindings.

## Open questions
- Make the marketplace repo public if private updates ever fail?
- Network security, Nora's phone and secret manager: scope and current setup unknown.

## File map
- `claude/settings.json`: tracked Claude settings (plugins, model, plain ccstatusline status line)
- `claude/CLAUDE.md`: global instructions
- `readme.md`: new-machine setup steps (step 2 shell env incl. `claude()` function, step 5 quota via untracked settings file, step 6 plugins)
- `herdr/config.toml`: herdr config incl. quota sidebar rows and custom keys
- `~/claude-marketplace/.claude-plugin/marketplace.json`: the marketplace
- `~/claude-marketplace/plugins/{adversarial-reviewer,thinking-red-team}/`: vendored skills plus LICENSE and provenance README
- `~/claude-marketplace/plan/marketplace-setup.md`: the plan
