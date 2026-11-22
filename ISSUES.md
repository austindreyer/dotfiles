## Open Issues

| # | Description | Priority | Added |
|---|-------------|----------|-------|
| 1 | Launch `herdr` from kitty and confirm Claude panes show idle/working/blocked and macOS notifications fire | High | 2026-11-21 |
| 3 | kitty.conf sets `enabled_layouts` twice; the later `tall, stack` drops `splits`, so the `ctrl+shift+v/h` split mappings don't split as intended | Medium | 2026-11-21 |
| 7 | On this machine, run readme setup step 5 (herdr-agent-quota configure with `CLAUDE_SETTINGS_FILE`), confirm the sidebar shows Claude 5h/7d quota and the footer still shows ccstatusline, and keep the wrapper out of commits | Medium | 2026-11-21 |
| 4 | Commit or drop the pending nvim/kitty changes (ctrl+hjkl handoff, snacks/markdown plugins) | Low | 2026-11-21 |

## Resolved Issues

| # | Description | Resolved |
|---|-------------|----------|
| 2 | Installed Rust and the herdr-navigator and herdr-agent-usage plugins | 2026-11-21 |
| 5 | Added Rust to PATH in `~/.zshrc`; `cargo --version` works in a new shell | 2026-11-21 |
| 6 | Superseded by #7: the quota plugin ignores `CLAUDE_CONFIG_DIR`, so its configure step must run with `CLAUDE_SETTINGS_FILE` (readme setup step 5) | 2026-11-21 |
