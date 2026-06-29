# RESUME — kde6-themes

KDE Plasma 6.7 (Wayland, Fedora 44) theming repo. Two parts:
1. **`tokio-night/`** — Tokyo Night macOS-style **global theme** (color scheme, recolored Plasma
   desktop theme, Look & Feel with panels/blur/transparency, installer). Self-contained bundle.
2. **`padding/`** — git **submodule** (fork `git@github.com:mcardia/padding.git`): a TypeScript
   KWin script that adds gaps around **maximized + snapped** windows. Built with `npm run build`
   → `pkg/contents/code/main.js`.

> Detailed session state, debug notes, and next steps live in **`tmp/handoff.md`** (gitignored,
> local only). Read it first if present. This RESUME is the self-sufficient summary for a fresh clone.

## Git state
- Parent branch **`feature/tokio-night-theme`**, HEAD **`8a5747e`** (not pushed). Tags:
  `before-plan-tokyonight-macos`, `before-plan-per-side-gaps` (restore points).
- Submodule `padding/` on **`main`** @ `9c28262` (working: maximized+snap, single `gapSize`).
  Branch `per-side-gaps-wip` = a per-side-gaps refactor that **did not work** (parked).
- Fresh clone needs: `git submodule update --init padding`.

## Decoration: DONE (Klassy)
Window decoration switched from aurorae (MacTahoe) to **Klassy** (installed from OBS
`home:paulmcauley`, Fedora_44) because Klassy reports its corner radius to KWin so Better Blur DX
matches the corners (aurorae could not → blur "tip" artifact). The macOS look is finished and
approved: **small circular traffic-light buttons in Tokyo Night colours** (close `#f7768e`, min
`#e0af68`, max `#9ece6a`), symbols on hover, window outline OFF, corner radius 6, buttons on the
left. This is a **Klassy preset** committed at `tokio-night/klassy/TokyoNight.klpw`.

Key gotchas (see `tmp/handoff.md`): Klassy reads `~/.config/klassy/klassyrc` group `[Windeco]`;
`kwriteconfig6`+reconfigure does NOT apply Klassy button style — only
`klassy-settings --import-preset <f.klpw>` + `--load-windeco-preset <name>` does. Button colours
use a per-button JSON override: `ButtonOverrideColorsActiveClose={"BackgroundNormal":[r,g,b],...}`.

## Remaining integration (next session — was wrapping up)
- `tokio-night/install.sh`: after the L&F apply, run
  `klassy-settings --import-preset "$SCRIPT_DIR/klassy/TokyoNight.klpw" && klassy-settings
  --load-windeco-preset TokyoNight`, set decoration `library=org.kde.klassy`, `ButtonsOnLeft=XIA`.
  Add a Klassy presence check. (Defaults already point decoration to Klassy.)
- `docs/PREREQUISITES.md` + README: require **Klassy** (OBS repo) instead of the MacTahoe aurorae;
  keep Better Blur DX.
- Remove the now-dead `tokio-night/src/aurorae/TokyoNight-Dark/` + its install lines.
- Keep the INSTALLED L&F `defaults` synced with source after edits (`cp` to
  `~/.local/share/plasma/look-and-feel/org.kde.tokyonight.macos.desktop/contents/defaults`).

## Untracked, left as-is
`reference-padding/` (GPL spec copy) and `reload-padding.sh` (scratch). Live `~/.config` edits
(kwinrc decoration/blur, `~/.config/klassy/klassyrc`) are NOT in git — the committed Klassy preset
reproduces them.

## Build / install quick ref
- Padding: `cd padding && npm install && npm run build`; `./install.sh` (kpackagetool6 + enable).
- Theme: `cd tokio-night && ./install.sh` (backs up live config; `--uninstall` to revert).
- KWin reload after config: `qdbus-qt6 org.kde.KWin /KWin reconfigure` (note: does NOT reload a
  KWin *script's* code — toggle the plugin for that).

## Operating notes
- **"aguarde"/"wait" = stop all actions** until told to proceed (we collided on live config once).
- Commits require explicit approval. `gh` CLI token is currently invalid; push over SSH works.
