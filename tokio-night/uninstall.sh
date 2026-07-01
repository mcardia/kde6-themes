#!/usr/bin/env bash
#
# uninstall.sh — revert the Tokyo Night (macOS) global theme and remove its assets.
#
# Restores a safe Breeze baseline (Breeze decoration + Breeze Dark colors), then
# removes the installed copies. The live config backed up by install.sh is left in
# place under $XDG_DATA_HOME/tokio-night-backups for manual restore if desired.
#
set -euo pipefail

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

DEST_COLORS="$DATA_HOME/color-schemes"
DEST_DESKTOPTHEME="$DATA_HOME/plasma/desktoptheme"
DEST_LNF="$DATA_HOME/plasma/look-and-feel"
DEST_KONSOLE="$DATA_HOME/konsole"

LNF_ID="org.kde.tokyonight.macos.desktop"
KONSOLE_SCHEME="TokyoNight"

c_info() { printf '\033[1;34m::\033[0m %s\n' "$*"; }
c_ok()   { printf '\033[1;32mok\033[0m %s\n' "$*"; }
c_warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

c_info "Restoring a safe Breeze baseline…"
if command -v plasma-apply-lookandfeel >/dev/null 2>&1; then
    plasma-apply-lookandfeel -a org.kde.breezedark.desktop || c_warn "could not apply Breeze Dark look-and-feel."
fi
if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.breeze
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme   Breeze
fi
command -v plasma-apply-colorscheme  >/dev/null 2>&1 && plasma-apply-colorscheme  BreezeDark || true
command -v plasma-apply-desktoptheme >/dev/null 2>&1 && plasma-apply-desktoptheme breeze-dark || true

c_info "Removing installed Tokyo Night assets…"
rm -f  "$DEST_COLORS/TokyoNight.colors"                  && c_ok "removed color scheme"
rm -rf "$DEST_DESKTOPTHEME/Tokyo-Night"                  && c_ok "removed desktop theme"
rm -rf "$DEST_LNF/$LNF_ID"                               && c_ok "removed look-and-feel package"

# Konsole: revert the default profile to Breeze only if it still points at ours,
# then remove the scheme file (don't clobber a user's own later choice).
if command -v kreadconfig6 >/dev/null 2>&1; then
    KPROF="$(kreadconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile 2>/dev/null || true)"
    if [ -n "$KPROF" ] && [ -f "$DEST_KONSOLE/$KPROF" ] && command -v kwriteconfig6 >/dev/null 2>&1; then
        CUR="$(kreadconfig6 --file "$DEST_KONSOLE/$KPROF" --group Appearance --key ColorScheme 2>/dev/null || true)"
        [ "$CUR" = "$KONSOLE_SCHEME" ] \
            && kwriteconfig6 --file "$DEST_KONSOLE/$KPROF" --group Appearance --key ColorScheme Breeze
    fi
fi
rm -f  "$DEST_KONSOLE/$KONSOLE_SCHEME.colorscheme"       && c_ok "removed konsole scheme"

# Remove the Albert autostart entry. The Albert package and its OBS repo are left
# in place — they may be in use outside this theme; remove them manually if desired.
rm -f  "$CONFIG_HOME/autostart/albert.desktop"           && c_ok "removed Albert autostart"

# Reconfigure KWin.
if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
elif command -v qdbus-qt6 >/dev/null 2>&1; then
    qdbus-qt6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

# Disable/remove the Padding KWin script (sibling submodule), if present.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -f "$SCRIPT_DIR/../padding/uninstall.sh" ]; then
    bash "$SCRIPT_DIR/../padding/uninstall.sh" || c_warn "padding uninstall reported an issue."
fi

if [ -f "$DATA_HOME/tokio-night-backups/latest" ]; then
    c_info "Pre-install config backup: $(cat "$DATA_HOME/tokio-night-backups/latest")"
fi
c_ok "Uninstalled. Log out/in to fully reset panels if needed."
