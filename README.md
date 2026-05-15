# Maintaining-Script-Fedora

Dialog-based TUI for Fedora system maintenance — update, clean, install packages, view system info, and shutdown.

## Requirements

- **Fedora** Linux (uses `dnf`, `/etc/os-release`)
- **`dialog`** package (script checks and exits with install hint if missing)
- **Root** access (script checks `whoami`)

## Usage

```sh
sudo bash maintaining_dialog.sh
```

## Features

| Menu option | What it does |
|---|---|
| Atualizar o Sistema | `dnf update --refresh`, `flatpak update`, `snap refresh` |
| Limpar o Sistema | `dnf autoremove`, `dnf remove --oldinstallonly`, `dnf clean all`, `flatpak uninstall --unused` |
| Instalar Aplicações | Prompts for package manager (DNF/Flatpak/Snap) and app name(s) |
| Informações do Sistema | Shows distro name, version, kernel, architecture |
| Desligar o Sistema | `poweroff` with confirmation |