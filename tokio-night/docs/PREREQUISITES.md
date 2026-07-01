# Prerequisites — Tokyo Night (macOS)

The theme ships its own recolored color scheme, Plasma desktop theme and Look & Feel package,
plus a Klassy decoration preset. It does **not** depend on any third-party plasmoid, but it
needs two external pieces installed: the **Klassy** window decoration (the macOS window buttons)
and a KWin **blur** effect.

The panels are native Plasma panels:

- **Color** comes from the Tokyo Night Plasma desktop theme (its panel background is a
  stylesheet SVG that follows the active color scheme).
- **Transparency** comes from that theme's translucent panel background plus the panel
  Opacity = Translucent setting (carried in the layout).
- **Blur** is rendered by a KWin blur effect behind the translucent panel.

## Required: Klassy window decoration

Provides the macOS-style small circular **traffic-light buttons** (recolored to the Tokyo Night
palette) and reports its corner radius to KWin so the blur rounds to match the window corners.
The theme ships a Klassy preset at `klassy/TokyoNight.klpw` that `install.sh` applies via
`klassy-settings --import-preset` + `--load-windeco-preset TokyoNight`.

- Requires **Klassy 6.3+** (KDecoration3 / Plasma 6.3+); tested on Plasma 6.7.
- Fedora (from the maintainer's OBS repo):
  ```sh
  sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:/paulmcauley/Fedora_44/home:paulmcauley.repo
  sudo dnf install klassy
  ```
  Other distros: see https://github.com/paulmcauley/klassy (OBS repos for openSUSE,
  Debian/Ubuntu, Arch/Manjaro, Mageia).
- Without Klassy the theme still applies (colors, panels, blur), but the window
  buttons/corners won't be the macOS style.

## Recommended for the best look

### Better Blur DX (KWin effect)
Gives panels, menus and decorations the macOS-style "vibrancy".

- Source: https://github.com/xarblu/kwin-effects-better-blur-dx
- Provides the KWin effect id `better_blur_dx` (config group `Effect-better-blur-dx`).
- The theme enables it and sets Strength 8 / Noise 2, with `BlurDocks` on, via the Look &
  Feel `defaults`.

If Better Blur DX is not installed, the **stock KWin "Blur" effect** also blurs translucent
panels — enable it in *System Settings → Desktop Effects → Blur*. Without any blur effect the
panels are still translucent, just not blurred.

## Albert launcher (installed automatically, non-official repo)

The theme uses **Albert** as a macOS Spotlight-style launcher and adds it to the KDE autostart
(`~/.config/autostart/albert.desktop`). `install.sh` installs it for you, but Albert is **not**
in the official Fedora repositories — it comes from the maintainer's **non-official** openSUSE
Build Service repo `home:manuelschneid3r`.

- On Fedora, `install.sh` adds that repo (for the detected Fedora version) and runs
  `sudo dnf install -y albert` — so it will prompt for your password and to import the repo's
  GPG key. If Albert is already installed, only the autostart entry is written.
- Equivalent manual install:
  ```sh
  sudo dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:/manuelschneid3r/Fedora_$(rpm -E %fedora)/home:manuelschneid3r.repo
  sudo dnf install albert
  ```
  Other distros: see https://albertlauncher.github.io/installing/.
- `uninstall.sh` removes only the autostart entry; the Albert package and its repo are left in
  place (remove them manually if you don't want them).

## Standard Plasma widgets

Used by the panels and normally preinstalled:

- `org.kde.plasma.icontasks` (bottom dock)
- `org.kde.plasma.colorpicker` (top panel, optional)

## Environment

- KDE Plasma 6 (developed/tested on 6.7.1, Wayland).
- `kwriteconfig6` / `plasma-apply-*` tools and a Qt6 D-Bus CLI (`qdbus6` or `qdbus-qt6`),
  all shipped with Plasma, for `install.sh`.
