# Prerequisites — Tokyo Night (macOS)

The theme ships its own recolored visual assets (color scheme, Plasma desktop theme, window
decoration, Look & Feel package) and does **not** depend on any third-party plasmoid.

The panels are native Plasma panels:

- **Color** comes from the Tokyo Night Plasma desktop theme (its panel background is a
  stylesheet SVG that follows the active color scheme).
- **Transparency** comes from that theme's translucent panel background plus the panel
  Opacity = Translucent setting (carried in the layout).
- **Blur** is rendered by a KWin blur effect behind the translucent panel.

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

## Standard Plasma widgets

Used by the panels and normally preinstalled:

- `org.kde.plasma.icontasks` (bottom dock)
- `org.kde.plasma.colorpicker` (top panel, optional)

## Environment

- KDE Plasma 6 (developed/tested on 6.7.1, Wayland).
- `kwriteconfig6` / `plasma-apply-*` tools and a Qt6 D-Bus CLI (`qdbus6` or `qdbus-qt6`),
  all shipped with Plasma, for `install.sh`.
