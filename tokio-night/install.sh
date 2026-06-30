#!/usr/bin/env bash
#
# install.sh — install and apply the Tokyo Night (macOS) global theme on KDE Plasma 6.
#
# The theme ships its own color scheme, Plasma desktop theme, Look & Feel package
# (panels/blur/transparency travel inside it), and a Klassy window-decoration preset
# for the macOS traffic-light buttons. No Panel Colorizer / Material You plasmoid is
# required. Klassy is an external prerequisite (see docs/PREREQUISITES.md).
#
set -euo pipefail

# --- paths -------------------------------------------------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SRC="$SCRIPT_DIR/src"

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

DEST_COLORS="$DATA_HOME/color-schemes"
DEST_DESKTOPTHEME="$DATA_HOME/plasma/desktoptheme"
DEST_LNF="$DATA_HOME/plasma/look-and-feel"

LNF_ID="org.kde.tokyonight.macos.desktop"
COLORSCHEME="TokyoNight"
DESKTOPTHEME="Tokyo-Night"
KLASSY_PRESET="$SCRIPT_DIR/klassy/TokyoNight.klpw"
KLASSY_PRESET_NAME="TokyoNight"

# --- helpers -----------------------------------------------------------------
c_info()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
c_ok()    { printf '\033[1;32mok\033[0m %s\n' "$*"; }
c_warn()  { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

usage() {
    cat <<EOF
Tokyo Night (macOS) — installer

Usage: ./install.sh [options]

Options:
  -n, --no-apply     Copy assets only; do not apply the theme.
  -u, --uninstall    Run uninstall.sh instead.
  -h, --help         Show this help.
EOF
}

# --- argument parsing --------------------------------------------------------
APPLY=1
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--no-apply) APPLY=0; shift ;;
        -u|--uninstall) exec "$SCRIPT_DIR/uninstall.sh" ;;
        -h|--help) usage; exit 0 ;;
        *) c_warn "unknown option: $1"; usage; exit 2 ;;
    esac
done

# --- prerequisite checks (warn only) -----------------------------------------
check_prereqs() {
    c_info "Checking prerequisites (warnings only)…"
    local missing=0
    # Better Blur DX effect provides the panel/menu vibrancy.
    if ! find /usr/lib*/qt6/plugins/kwin/effects "$DATA_HOME/kwin" -iname '*better_blur*' 2>/dev/null | grep -q .; then
        c_warn "Better Blur DX effect not found — panels will be translucent but not blurred."
        c_warn "The stock KWin Blur effect also works; see docs/PREREQUISITES.md."
        missing=1
    fi
    # Klassy decoration provides the macOS traffic-light buttons + KWin-reported corners.
    if ! find /usr/lib*/qt6/plugins/org.kde.kdecoration3 -iname 'org.kde.klassy.so' 2>/dev/null | grep -q . \
       && ! command -v klassy-settings >/dev/null 2>&1; then
        c_warn "Klassy decoration not found — window buttons/corners won't apply."
        c_warn "Install it from the OBS repo; see docs/PREREQUISITES.md."
        missing=1
    fi
    [ "$missing" -eq 0 ] && c_ok "All prerequisites present." \
        || c_warn "See docs/PREREQUISITES.md."
}

# --- install assets ----------------------------------------------------------
install_assets() {
    c_info "Installing theme assets…"
    mkdir -p "$DEST_COLORS" "$DEST_DESKTOPTHEME" "$DEST_LNF"

    install -m 0644 "$SRC/color-schemes/$COLORSCHEME.colors" "$DEST_COLORS/"
    c_ok "color scheme -> $DEST_COLORS/$COLORSCHEME.colors"

    rm -rf "$DEST_DESKTOPTHEME/$DESKTOPTHEME"
    cp -a "$SRC/desktoptheme/$DESKTOPTHEME" "$DEST_DESKTOPTHEME/"
    c_ok "desktop theme -> $DEST_DESKTOPTHEME/$DESKTOPTHEME"

    rm -rf "$DEST_LNF/$LNF_ID"
    cp -a "$SRC/look-and-feel/$LNF_ID" "$DEST_LNF/"
    c_ok "look-and-feel -> $DEST_LNF/$LNF_ID"
}

# --- backup live config ------------------------------------------------------
backup_config() {
    local stamp ts_dir
    stamp="$(date +%Y%m%d-%H%M%S)"
    ts_dir="$DATA_HOME/tokio-night-backups/$stamp"
    mkdir -p "$ts_dir"
    for f in kdeglobals kwinrc plasma-org.kde.plasma.desktop-appletsrc ksplashrc plasmarc; do
        [ -f "$CONFIG_HOME/$f" ] && cp -a "$CONFIG_HOME/$f" "$ts_dir/" || true
    done
    c_ok "Backed up live config to $ts_dir"
    echo "$ts_dir" > "$DATA_HOME/tokio-night-backups/latest"
}

# Pick whichever Qt6 D-Bus CLI is present.
qdbus_cli() {
    if command -v qdbus6 >/dev/null 2>&1; then qdbus6 "$@"
    elif command -v qdbus-qt6 >/dev/null 2>&1; then qdbus-qt6 "$@"
    else return 1; fi
}

kwin_reconfigure() { qdbus_cli org.kde.KWin /KWin reconfigure 2>/dev/null || true; }

# Write a kwinrc key (kwriteconfig6 only; warn if absent).
kw() { kwriteconfig6 --file kwinrc --group "$1" --key "$2" "$3"; }

# --- apply -------------------------------------------------------------------
# plasma-apply-lookandfeel via CLI does NOT rebuild panels and does NOT load the
# kwin effect (blur/translucency) keys from contents/defaults. So we apply every
# component explicitly and pass --resetLayout to actually load the theme's panels.
apply_theme() {
    c_info "Applying the global theme…"

    # 1) Colors + Plasma desktop theme (reliable, dedicated tools).
    command -v plasma-apply-colorscheme  >/dev/null 2>&1 && plasma-apply-colorscheme  "$COLORSCHEME" || true
    command -v plasma-apply-desktoptheme >/dev/null 2>&1 && plasma-apply-desktoptheme "$DESKTOPTHEME" || true

    # 2) Global theme + REBUILD PANELS. --resetLayout loads contents/layouts/*.js.
    if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
        plasma-apply-lookandfeel -a "$LNF_ID" --resetLayout \
            || c_warn "plasma-apply-lookandfeel reported an issue."
        c_ok "look-and-feel applied (panels rebuilt)"
    else
        c_warn "plasma-apply-lookandfeel not found; loading panel layout via D-Bus…"
        local lay="$DEST_LNF/$LNF_ID/contents/layouts/org.kde.plasma.desktop-layout.js"
        [ -f "$lay" ] && qdbus_cli org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$lay")" >/dev/null 2>&1 || true
    fi

    # 3) kwin keys that look-and-feel does NOT apply: decoration, blur, translucency.
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kw org.kde.kdecoration2 library org.kde.klassy
        kw org.kde.kdecoration2 ButtonsOnLeft  XIA
        kw org.kde.kdecoration2 ButtonsOnRight ""

        kw Plugins better_blur_dxEnabled true
        kw Plugins blurEnabled false

        kw Effect-better-blur-dx BlurStrength    8
        kw Effect-better-blur-dx NoiseStrength   2
        kw Effect-better-blur-dx BlurDocks       true
        kw Effect-better-blur-dx BlurMenus       true
        kw Effect-better-blur-dx BlurDecorations true
        kw Effect-better-blur-dx BlurNonMatching true
        kw Effect-better-blur-dx CornerRadius    6

        kw Effect-translucency Dialogs    89
        kw Effect-translucency Inactive   90
        kw Effect-translucency MoveResize 90

        kwriteconfig6 --file ksplashrc --group KSplash --key Theme "$LNF_ID" || true
        c_ok "kwin decoration + blur + translucency written"
    else
        c_warn "kwriteconfig6 not found; blur/translucency/decoration not applied."
    fi

    # 3b) Klassy decoration style: macOS small circular traffic-light buttons in the
    # Tokyo Night palette, no window outline. kwriteconfig6 does NOT apply Klassy's
    # button style — only klassy-settings does (it writes ~/.config/klassy/klassyrc).
    if command -v klassy-settings >/dev/null 2>&1 && [ -f "$KLASSY_PRESET" ]; then
        klassy-settings --import-preset "$KLASSY_PRESET" >/dev/null 2>&1 || true
        klassy-settings --load-windeco-preset "$KLASSY_PRESET_NAME" >/dev/null 2>&1 || true
        c_ok "Klassy preset applied ($KLASSY_PRESET_NAME)"
    else
        c_warn "klassy-settings/preset missing — Tokyo Night window buttons not applied."
        c_warn "Install Klassy; see docs/PREREQUISITES.md."
    fi

    # 4) Reload KWin so decoration/blur/translucency take effect now.
    kwin_reconfigure
    c_ok "Applied. If the dock/menu bar still looks stale, log out and back in once."
}

# --- padding KWin script (sibling submodule) ---------------------------------
# Also install + enable the "Padding" KWin script. It lives in the sibling
# `padding/` git submodule; if it is not checked out, warn and skip (don't fail).
install_padding() {
    local pad="$SCRIPT_DIR/../padding/install.sh"
    if [ -f "$pad" ]; then
        c_info "Installing the Padding KWin script…"
        bash "$pad" || c_warn "padding install reported an issue."
    else
        c_warn "padding submodule not checked out — run: git submodule update --init padding"
        c_warn "(skipping the Padding KWin script.)"
    fi
}

# --- main --------------------------------------------------------------------
check_prereqs
install_assets
if [ "$APPLY" -eq 1 ]; then
    backup_config
    apply_theme
    install_padding
else
    c_info "Assets installed; --no-apply set, not applying."
fi
c_ok "Done."
