<div align="center">

# Liquid Desktop · Dotfiles

**A personal Manjaro desktop built around Hyprland, Noctalia, and optical glass.**

[![Platform](https://img.shields.io/badge/platform-Manjaro-35bf5c?style=flat-square)](https://manjaro.org/)
[![Compositor](https://img.shields.io/badge/Hyprland-0.57.0-58c4dc?style=flat-square)](https://hyprland.org/)
[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue?style=flat-square)](LICENSE)

Glass contours · Attached panels · Floating windows · Theme-aware GTK

[Setup](#setup) · [Keybindings](#keybindings) · [Customization](#customization) · [Rollback](#rollback)

</div>

## The desktop

This repository preserves the configuration used on my laptop. The visual effect combines compositor rendering with application-specific background styles: text, icons, and video retain their own opacity.

- **Hyprland:** Lua configuration, rounded windows, floating by default, keyboard resizing, and touchpad workspace gestures.
- **Noctalia:** a translucent top bar, attached dropdowns, dock, notifications, and OSD. Native shell borders and heavy panel shadows are disabled so the custom glass contour can define the edge.
- **Hyprglass:** separate optical presets for application windows and shell surfaces, with modest blur and refraction. Hyprland's native blur is disabled.
- **GTK:** material overrides for Nautilus, GTK3 file choosers, and Pamac, with separate sidebar treatment and theme-aware colors.
- **Theme synchronization:** Noctalia-generated palettes, GTK preferences, XSettings, and a portal refresh service that waits for open GTK file dialogs to close.
- **Cursor and typography:** Bibata Modern Ice, Tela icons, and Plus Jakarta Sans.

This is a personal desktop profile, not a distribution or an automatic machine provisioning tool. Review the monitor layout and idle behavior before installing it elsewhere.

## Companion projects

| Repository | Responsibility |
| --- | --- |
| **[dotfiles](https://github.com/adenanteng/dotfiles)** | Desktop configuration, GTK styles, startup loader, and theme services |
| **[hyprglass-liquid](https://github.com/adenanteng/hyprglass-liquid)** | Modified HyprGlass plugin, optical shaders, build instructions, and rendering checks |
| **[chatgpt-liquid](https://github.com/adenanteng/chatgpt-liquid)** | Separate, version-sensitive ChatGPT application patch |

Installing these dotfiles does not compile the plugin or patch ChatGPT. Opaque applications stay opaque unless they support transparency or receive a separate background-only integration.

## Compatibility

| Component | Profile baseline |
| --- | --- |
| OS | Manjaro Linux |
| Compositor | Hyprland **0.57.0**, native Lua configuration |
| Shell | Noctalia **5.2.1**, settings schema **14** |
| Optical plugin | Custom **1.1.1-optical-rim** build from `hyprglass-liquid` |
| GTK theme | `adw-gtk3` / `adw-gtk3-dark` |
| Default palette | Noctalia community palette **ADW**, dark mode |
| Displays | `HDMI-A-1`: 1920×1080 above `eDP-1`: 1920×1200, scale 1 |

Older Hyprland `.conf` configurations and Quickshell-era Noctalia setups are outside this profile. Native plugins must be rebuilt against the running compositor's matching headers after ABI changes. The loader checks the recorded ABI and attempts the existing hyprpm fallback; it does not rebuild anything.

## Repository layout

```text
home/
├── .config/
│   ├── hypr/                  # Active Lua config, bootstrap colors, local overrides
│   ├── gtk-3.0/               # GTK3 palette, preferences, and material CSS
│   ├── gtk-4.0/               # GTK4 palette, preferences, and Nautilus CSS
│   ├── systemd/user/          # Theme watcher and XSettings services
│   └── xdg-desktop-portal/    # GTK file chooser backend selection
└── .local/
    ├── bin/                   # ABI-aware plugin loader and GTK refresh helper
    └── state/noctalia/         # Sanitized preferences snapshot only
install.py                     # Preview, backup, copy, and guarded file rollback
```

`noctalia.lua` and both `noctalia.css` files are generated palette snapshots included for first-start bootstrapping. Noctalia's enabled templates regenerate them later. Edit the theme through Noctalia rather than maintaining those generated colors by hand.

The Noctalia snapshot intentionally excludes avatar images, wallpaper/video paths, location preferences, and stale settings for an unused plugin. Clipboard contents, notes, notification history, credentials, caches, plugin binaries, build ABI metadata, and application profiles are not included.

## Setup

### 1. Install prerequisites

Have a working Hyprland session before applying this profile. Install compatible versions of:

- Hyprland, `hyprctl`, and `hyprpm`;
- Noctalia, its runtime dependencies, and the **ADW** community palette;
- GTK3/GTK4, `adw-gtk3`, and the GTK and Hyprland desktop portal backends;
- Python **3.11+** for installation and checks, Bash, `jq`, and `flock`;
- `xsettingsd`, with its executable in `~/.local/bin` or `/usr/bin`;
- Kitty, Bibata Modern Ice, Tela icons, and Plus Jakarta Sans;
- optional Noctalia **notes** and **mpvpaper** plugins, plus their dependencies.

The theme snapshot enables several Noctalia application templates, including community templates. Install the corresponding integrations or deselect templates for applications you do not use. Plugin code, fonts, themes, and community assets are not vendored here.

Build and install the custom plugin using the **[hyprglass-liquid installation guide](https://github.com/adenanteng/hyprglass-liquid#installation)**. Its runtime installation supplies `~/.local/share/hyprglass-local/abi` and `plugin-path`; these machine-specific files are deliberately excluded from dotfiles. Keep a compatible hyprpm-managed upstream installation for fallback.

### 2. Clone and review

```bash
git clone https://github.com/adenanteng/dotfiles.git
cd dotfiles
python3 install.py
```

The default command only lists destination files. Before applying:

1. Edit monitor modes, positions, and workspace assignments in `home/.config/hypr/hyprland.lua`.
2. Adjust monitor-specific desktop and lock-screen widget geometry in `home/.local/state/noctalia/settings.toml`.
3. Review idle timers: screen off at 120 seconds, suspend with locking at 900 seconds; the separate timed lock action is disabled. Verify locking works on your own machine.
4. Review the enabled plugins and theme templates in that same snapshot.

The installer targets the conventional `$HOME/.config` and `$HOME/.local` layout. Custom XDG directory layouts require adapting the profile and helpers first.

### 3. Copy the profile

Quit Noctalia before applying, so it cannot write its old preferences over the imported snapshot. Keep a terminal open while making desktop configuration changes.

```bash
python3 install.py --apply
```

This **replaces the listed files**, including Noctalia's app-managed `settings.toml`, after backing up every existing destination. It copies files instead of creating symlinks. Existing file symlinks are backed up as symlinks and replaced locally; their targets are not overwritten. Unrelated files and histories are left alone.

The script prints a unique backup directory under `~/.local/state/dotfiles/backups/`. Save that path. The installer does not enable services, reload Hyprland, launch Noctalia, or run native plugin code.

If you already maintain `~/.config/noctalia/*.toml` files, reconcile them with this snapshot before starting Noctalia; configuration sources and GUI-managed overrides can otherwise disagree. This profile deliberately uses the same app-managed preferences location as the original desktop.

### 4. Activate

Start Noctalia again, then initialize the appearance services:

```bash
systemctl --user daemon-reload
python3 "$HOME/.local/bin/hyprglass-refresh-gtk-portal"
systemctl --user enable --now hyprglass-xsettings.service hyprglass-gtk-portal.path
hyprctl reload
```

The refresh command needs Noctalia IPC and the current Hyprland session. Close GTK file dialogs first; the helper intentionally waits while one is open. The initial refresh writes the XSettings theme configuration before the service is enabled.

The Hyprland startup hook loads Noctalia and the plugin loader at login. To activate an already-installed plugin during the current session:

```bash
"$HOME/.local/bin/hyprglass-local-load"
hyprctl hyprglass status
hyprctl configerrors
```

Select your own avatar and wallpaper/video through Noctalia. Relaunch GTK applications that cache their CSS at startup. Check light and dark mode, a GTK upload dialog, Nautilus, and Pamac before relying on the setup.

## Keybindings

`Super` is the Windows/Meta key.

| Keys | Action |
| --- | --- |
| `Super + Space` | Launcher |
| `Super + S` | Control center |
| `Super + ,` | Noctalia settings |
| `Super + T` | Kitty |
| `Super + V` | Clipboard |
| `Super + Q` | Close focused window |
| `Super + F` / `Super + Shift + F` | Set maximized / fullscreen |
| `Super + Shift + T` | Toggle floating |
| `Super + W` | Toggle window group |
| `Super + Arrow` | Directional focus |
| `Super + Shift + Arrow` | Move window |
| `Super + 1…9` | Select workspace |
| `Super + Shift + 1…9` | Move window to workspace |
| `Ctrl + Super + Left/Right` | Previous/next workspace |
| `Ctrl + Super + Shift + Left/Right` | Move window to previous/next workspace |
| `Super + - / =` | Reduce/increase width; repeat while held |
| `Super + Shift + - / =` | Reduce/increase height by 50 px; repeat while held |
| `Super + Left/Right mouse drag` | Move/resize window |
| `Super + Shift + S` | Region screenshot |
| Four-finger horizontal swipe | Switch workspace |

The original width bindings include both symbolic minus/equal keys (50 px) and physical keycodes 20/21 (100 px). They are preserved from the working desktop; these can overlap on some layouts. Keep only your preferred pair if resizing steps feel larger than expected.

## Customization

- **Glass strength:** change `tahoe-window`, `liquid-shell`, `liquid-attached`, and `liquid-dock` in the main Lua config. Window blur is `0.60`; shell blur is `0.85`. Native Hyprland blur stays disabled to avoid combining two blur treatments.
- **Application backgrounds:** GTK overrides use a 50% base paint and a separate 20% sidebar overlay. Composited results depend on underlying layers; these values are not whole-window opacity. Text and controls retain their opacity.
- **Shell material:** adjust Noctalia's bar/dock opacity, panel transparency mode, and radius together with the shader presets. Re-enabling native shell borders can create doubled outlines.
- **Machine overrides:** `hyprland-gui.lua` is an initially empty override module loaded last. Keep it present even if you do not use HyprMod.
- **Theme:** use Noctalia's theme controls. Generated GTK palettes trigger the path watcher; the helper updates GTK theme names and XSettings, then restarts an active GTK portal once its dialogs are closed.

GTK4's exported `gtk.css` includes only existing palette/material files. Two dangling imports from a previous local theme were intentionally excluded. Legacy Hyprland `.conf` files and trial backups are also excluded.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Glass disappears after updating Hyprland | Read `~/.local/state/hyprglass-local/startup.log`; rebuild the plugin against the new compositor ABI. Do not merely replace the ABI record. |
| Shell shows ordinary blur or weak contours | Confirm `hyprctl hyprglass status` reports the custom optical build and ready shaders. Stock fallback rendering differs. |
| Noctalia widgets or palette are missing | Install the enabled plugins/community palette or choose available alternatives in settings. |
| GTK remains dark after switching themes | Inspect `systemctl --user status hyprglass-gtk-portal.path hyprglass-xsettings.service` and the refresh service journal; confirm `xsettingsd` is installed. Relaunch apps that cache CSS. |
| Upload dialog colors lag behind | Close existing dialogs and inspect `journalctl --user -u hyprglass-gtk-portal.service`. Portal refresh is deferred while a GTK portal dialog is open. |
| Cursor falls back | Install `Bibata-Modern-Ice` and check `hyprctl setcursor Bibata-Modern-Ice 24`. |
| Desktop is misplaced on another machine | Adapt output names, resolution, positions, workspace rules, and widget coordinates before installation. |

## Rollback

Quit Noctalia. If you enabled the services for the first time during installation, disable them before restoring files:

```bash
systemctl --user disable --now hyprglass-gtk-portal.path hyprglass-xsettings.service
systemctl --user stop hyprglass-gtk-portal.service
python3 install.py --restore "$HOME/.local/state/dotfiles/backups/profile-REPLACE_ME"
systemctl --user daemon-reload
```

Use the actual backup directory printed during installation. Existing files and symlinks are restored; files introduced by the installation are removed. The rollback preflight refuses to overwrite files changed since installation. Noctalia commonly regenerates palette files or saves preferences, so compare those files against the backup and restore them manually when necessary.

Restart Noctalia and reload the restored Hyprland configuration. Restore any services that were enabled before installation according to their previous state. Service enablement is manual and is not captured by the file installer. Generated XSettings runtime configuration may remain under `~/.config/hyprglass-local/`; it is harmless with the service stopped.

Plugin binaries and ABI records are untouched by this installer. To remove the optical runtime as well, follow the companion plugin repository's rollback instructions.

## Maintenance and checks

The installation is a snapshot, not a live link. After local configuration changes, copy only the relevant reviewed files back into `home/` and sanitize personal paths before committing. Do not export entire state directories.

```bash
python3 tests/check_profile.py
python3 tests/check_install.py
bash -n home/.local/bin/hyprglass-local-load
luac -p home/.config/hypr/hyprland.lua
```

The checks cover profile parsing/imports/privacy constraints and installer backup/rollback behavior in a temporary home. They do not boot a new desktop or establish compatibility with later compositor/shell releases. No clean-machine installation or fresh-login validation has been performed for this exported repository.

## Credits and license

Built on [Hyprland](https://hyprland.org/), [Noctalia](https://github.com/noctalia-dev/noctalia), [HyprGlass](https://github.com/hyprnux/hyprglass), and [adw-gtk3](https://github.com/lassekongo83/adw-gtk3). The loader, GTK integration, and service files are carried over from [hyprglass-liquid](https://github.com/adenanteng/hyprglass-liquid); generated palette snapshots come from Noctalia.

Distributed under the [BSD 3-Clause License](LICENSE), retaining the inherited HyprGlass notice. Companion projects and external assets retain their own licenses. This is a community configuration, not an official Hyprland or Noctalia release.
