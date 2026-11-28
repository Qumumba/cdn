# Tools

## Progress bars

`generate_progress_bars.py` draws the 101 progress bar images in `progress/`, from `progress-0.png` to `progress-100.png` in 1% steps.
Each one is a 1810x32 px pill on a transparent background, drawn at 4x and downsampled with LANCZOS.
Discord stretches a message image to the full message width, so the bar is drawn at twice a typical desktop width to stay sharp, with no text on it; the percentage goes in the message text instead.
The colours are the constants at the top of the script, taken from the Hydration dark theme (`--panel-line` and `--accent-icon`).

To re-run it after changing a colour or size:

```sh
python3 -m venv .venv
.venv/bin/pip install pillow
.venv/bin/python tools/generate_progress_bars.py
```

Run it from anywhere; it always writes to the `progress/` folder at the repo root.
