# kde6-themes

A collection of complete, self-contained global themes for **KDE Plasma 6**.

Each theme lives in its own directory and ships its own recolored copies of every visual
component (color scheme, Plasma desktop theme, window decorations, Look & Feel package) —
no dependency on other installed themes. Every theme has its own `install.sh` / `uninstall.sh`.

![Tokyo Night (macOS) theme](tokio-night/docs/screenshot.png)

## Themes

| Theme | Directory | Description |
|-------|-----------|-------------|
| Tokyo Night (macOS) | [`tokio-night/`](tokio-night/) | Tokyo Night palette + macOS-style top panel and floating bottom dock, with native translucent panels and blur. |

## Usage

```sh
cd <theme-directory>
./install.sh            # install and apply
./install.sh --help     # options
./install.sh --uninstall
```

See each theme's own `README.md` for prerequisites and options — for example
[tokio-night/README.md](tokio-night/README.md).
