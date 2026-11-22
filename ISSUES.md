## Open Issues

| # | Description | Priority | Added |
|---|-------------|----------|-------|
| 1 | Launch `herdr` from kitty and confirm Claude panes show idle/working/blocked and macOS notifications fire | High | 2026-11-21 |
| 6 | herdr-agent-quota shows Claude quota only after its "Install / repair agent quota" action adds a statusLine to `claude/settings.json`; run it from inside herdr and review the diff | Medium | 2026-11-21 |
| 3 | kitty.conf sets `enabled_layouts` twice; the later `tall, stack` drops `splits`, so the `ctrl+shift+v/h` split mappings don't split as intended | Medium | 2026-11-21 |
| 7 | Claude Code allows only one `statusLine`; ccstatusline now owns it, so herdr's "Install / repair agent quota" action (issue 6) would overwrite it. Decide which to keep before running that action | Medium | 2026-11-21 |
| 4 | Commit or drop the pending nvim/kitty changes (ctrl+hjkl handoff, snacks/markdown plugins) | Low | 2026-11-21 |

## Resolved Issues

| # | Description | Resolved |
|---|-------------|----------|
| 2 | Installed Rust and the herdr-navigator and herdr-agent-usage plugins | 2026-11-21 |
| 5 | Added Rust to PATH in `~/.zshrc`; `cargo --version` works in a new shell | 2026-11-21 |
