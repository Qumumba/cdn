from pathlib import Path

from PIL import Image, ImageDraw

TRACK_COLOUR = "#3F3F46"
FILL_COLOUR = "#C27AFF"
WIDTH = 400
HEIGHT = 20
RADIUS = 10
MIN_FILL = 20
SCALE = 4
STEPS = range(0, 101, 10)
OUTPUT = Path(__file__).resolve().parent.parent / "progress"


def fill_width(percent):
    if percent <= 0:
        return 0
    return max(MIN_FILL, round(WIDTH * min(percent, 100) / 100))


def render(percent):
    image = Image.new("RGBA", (WIDTH * SCALE, HEIGHT * SCALE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    radius = RADIUS * SCALE
    bottom = HEIGHT * SCALE - 1
    draw.rounded_rectangle((0, 0, WIDTH * SCALE - 1, bottom), radius, fill=TRACK_COLOUR)
    width = fill_width(percent)
    if width:
        draw.rounded_rectangle((0, 0, width * SCALE - 1, bottom), radius, fill=FILL_COLOUR)
    return image.resize((WIDTH, HEIGHT), Image.LANCZOS)


def main():
    OUTPUT.mkdir(exist_ok=True)
    for percent in STEPS:
        render(percent).save(OUTPUT / f"progress-{percent}.png", optimize=True)


if __name__ == "__main__":
    main()
