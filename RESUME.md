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

## Klassy packaging — DONE (#1–#4, UNCOMMITTED, ready to commit)
All four pendencies are applied in the working tree (lint clean, no orphan aurorae refs):
- **#1 `tokio-night/install.sh`** — removed dead aurorae handling; decoration → `org.kde.klassy`
  + `ButtonsOnLeft=XIA` + blur `CornerRadius=6`; imports/loads the Klassy preset via
  `klassy-settings`; `check_prereqs` warns if Klassy missing. Tested: `uninstall.sh` → Breeze,
  then `install.sh` reproduced everything (Klassy, TN colours, blur, padding).
- **#2** `git rm -r tokio-night/src/aurorae/TokyoNight-Dark/` (staged as deleted). Restore point:
  tag **`before-remove-aurorae`** (= commit 381914f, last state with the aurorae).
- **#3** `tokio-night/README.md` + `docs/PREREQUISITES.md` now require **Klassy** (OBS
  `home:paulmcauley` Fedora_44; install cmds in PREREQUISITES) instead of the MacTahoe aurorae.
- **#4** `tokio-night/uninstall.sh` — dropped the dead `DEST_AURORAE` var + aurorae-removal line
  (it already reverts decoration to Breeze).

**Next: ONE commit** of the working tree (install.sh, uninstall.sh, README, PREREQUISITES, the
aurorae deletions, RESUME) + push. (Needs operator approval.) After committing, keep the INSTALLED
L&F `defaults` synced with source if you re-edit it (`cp` to
`~/.local/share/plasma/look-and-feel/org.kde.tokyonight.macos.desktop/contents/defaults`).

## Future polish (deferred — fiddly, low impact)
- [ ] **Round the dock task-hover highlight** corners to match the panel radius (~10px). It is a
  9-slice in `tokio-night/src/desktoptheme/Tokyo-Night/widgets/tasks.svgz` (`hover-*` elements,
  hardcoded TN colours, `stroke:none`, hover-center `#7aa2f7` @ opacity 0.4); round the 4 corner
  paths (+ `focus`/`active` for consistency). Done blind → iterate. Cleaner alt: transplant a
  rounded hover 9-slice from the Breeze/default theme and recolour.
- [ ] **Running-app indicator → macOS dot.** Change the dock (icontasks) running-task indicator
  from KDE's bar/underline to a small dot like macOS. Investigate whether it is an icontasks
  setting, a `tasks.svgz` element, or needs a different task widget.

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
