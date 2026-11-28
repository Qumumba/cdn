# Tools

## Progress bars

`generate_progress_bars.py` draws the 11 progress bar images in `progress/`, from `progress-0.png` to `progress-100.png` in 10% steps.
Each one is a 400x20 px pill on a transparent background, drawn at 4x and downsampled with LANCZOS.
The track and fill colours are the constants at the top of the script, taken from the Hydration dark theme (`--panel-line` and `--accent-icon`).

To re-run it after changing a colour or size:

```sh
python3 -m venv .venv
.venv/bin/pip install pillow
.venv/bin/python tools/generate_progress_bars.py
```

Run it from anywhere; it always writes to the `progress/` folder at the repo root.
