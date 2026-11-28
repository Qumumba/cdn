# Tools

## Progress bars

`generate_progress_bars.py` draws the 101 progress bar images in `progress/`, from `progress-0.png` to `progress-100.png` in 1% steps.
Each one is a 400x20 px pill with its percentage after it in Inter Bold, on a transparent background, drawn at 4x and downsampled with LANCZOS.
The colours are the constants at the top of the script, taken from the Hydration dark theme (`--panel-line`, `--accent-icon` and zinc-100 text).
Inter is in `fonts/` under the SIL Open Font License (`fonts/OFL.txt`).

To re-run it after changing a colour or size:

```sh
python3 -m venv .venv
.venv/bin/pip install pillow
.venv/bin/python tools/generate_progress_bars.py
```

Run it from anywhere; it always writes to the `progress/` folder at the repo root.
