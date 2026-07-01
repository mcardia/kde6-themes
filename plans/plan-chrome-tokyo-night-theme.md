# Plan: Chrome Tokyo Night Theme

## Goal
Create a Google Chrome / Chromium browser theme matching the repo's Tokyo Night palette, bundled
self-contained inside `tokio-night/` (same pattern as the KDE assets: the theme dir owns its own
copies, no external references).

## Context
- Repo: `kde6-themes` — each theme lives in one self-contained directory; `tokio-night/` is the
  Tokyo Night bundle (KDE color scheme, desktop theme, Look & Feel, Klassy preset, wallpapers).
- Canonical palette (from `tokio-night/src/color-schemes/TokyoNight.colors`):

  | Role | Hex | RGB |
  |---|---|---|
  | bg darkest (frame) | `#16161e` | 22,22,30 |
  | bg base | `#1a1b26` | 26,27,38 |
  | bg highlight (toolbar) | `#24283b` | 36,40,59 |
  | accent blue | `#7aa2f7` | 122,162,247 |
  | fg bright | `#c0caf5` | 192,202,245 |
  | fg dim | `#a9b1d6` | 169,177,214 |
  | fg muted (inactive) | `#565f89` | 86,95,137 |
  | red | `#f7768e` | 247,118,142 |
  | yellow | `#e0af68` | 224,175,104 |
  | green | `#9ece6a` | 158,206,106 |

- A Chrome theme is a manifest-only extension: a directory with a single `manifest.json`
  (`manifest_version: 3`) containing a `theme` key with `colors`, `tints`, and `properties`.
  No code runs; images are optional. Chrome uses RGB integer arrays for colors.

## Steps

1. Create directory `tokio-night/chrome/tokyo-night/`.

2. Write `tokio-night/chrome/tokyo-night/manifest.json` with:
   - `manifest_version: 3`, `name: "Tokyo Night"`, `version: "1.0"`,
     `description: "Tokyo Night theme matching the kde6-themes Tokyo Night desktop."`
   - `theme.colors` (RGB arrays):
     - `frame`: [22,22,30] · `frame_inactive`: [22,22,30]
     - `toolbar`: [36,40,59]
     - `tab_text`: [192,202,245] (active tab) · `tab_background_text`: [86,95,137] (inactive tabs)
     - `toolbar_text`: [169,177,214] · `toolbar_button_icon`: [169,177,214]
     - `omnibox_background`: [26,27,38] · `omnibox_text`: [192,202,245]
     - `bookmark_text`: [169,177,214]
     - `ntp_background`: [26,27,38] · `ntp_text`: [192,202,245] · `ntp_link`: [122,162,247]
     - `button_background`: [36,40,59]
   - `theme.tints.buttons`: HSL tint toward the dim foreground so default icons match
     (e.g. `[0.62, 0.35, 0.75]`).
   - No images (colors-only theme keeps the bundle self-contained and tiny).

3. Verify the manifest parses: `python3 -m json.tool tokio-night/chrome/tokyo-night/manifest.json`.

4. Manual load test (operator step, document in README):
   open `chrome://extensions`, enable Developer mode, "Load unpacked", select
   `tokio-night/chrome/tokyo-night/`. Theme applies immediately; remove via
   `chrome://settings/appearance` → "Reset to default".

5. Visual check against the desktop: frame vs toolbar contrast, inactive-tab legibility,
   omnibox colors, new-tab page. Adjust RGB values only if a pairing is illegible;
   any adjustment must stay within the palette table above.

6. README changes:
   - `tokio-night/README.md`: add a "Chrome theme" section — what it is, the load-unpacked
     install steps from step 4, and how to remove it.
   - Root `README.md`: mention the Chrome theme as part of the Tokyo Night bundle.

7. Commit with message `theme: add Tokyo Night Chrome theme` (confirm with operator first,
   per session rules).

## Out of scope
- Publishing to the Chrome Web Store (needs a paid developer account; violates free-tooling
  preference for now — revisit only if the operator asks).
- NTP background image (the KDE wallpapers are 2560×1600 and would bloat the extension;
  Chrome's own NTP customization can point at the wallpaper file locally if wanted).
- Firefox port (different format — separate plan if desired).

## Acceptance criteria
- `manifest.json` is valid JSON and loads unpacked in Chrome without errors.
- All colors trace back to the palette table (no invented colors).
- READMEs updated; theme dir is fully self-contained under `tokio-night/chrome/`.
