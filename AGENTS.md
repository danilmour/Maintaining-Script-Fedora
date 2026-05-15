# AGENTS.md — Maintaining-Script-Fedora

Single-file bash script (`maintaining_dialog.sh`) providing a dialog-based TUI for Fedora system maintenance (update, clean, install, system info, shutdown).

## Commands

```sh
bash maintaining_dialog.sh          # run (must be root)
```

## Requirements

- `dialog` package must be installed (script checks and exits with install hint if missing)
- Script requires root (checks `whoami == "root"`)
- Fedora-specific (uses `dnf`, `/etc/os-release`)

## Info

- No tests, no build, no CI, no linters
- Labels are in Portuguese
- `.github/workflows` was deleted in commit c8b78e4 — no CI pipeline
