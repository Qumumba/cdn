from pathlib import Path

from PIL import Image, ImageDraw

TRACK_COLOUR = "#3F3F46"
FILL_COLOUR = "#C27AFF"
WIDTH = 1810
HEIGHT = 32
SCALE = 4
STEPS = range(0, 101)
OUTPUT = Path(__file__).resolve().parent.parent / "progress"


def fill_width(percent):
    if percent <= 0:
        return 0
    return max(HEIGHT, round(WIDTH * min(percent, 100) / 100))


def pill(draw, width, colour):
    draw.rounded_rectangle((0, 0, width * SCALE - 1, HEIGHT * SCALE - 1), HEIGHT * SCALE // 2, fill=colour)


def render(percent):
    image = Image.new("RGBA", (WIDTH * SCALE, HEIGHT * SCALE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    pill(draw, WIDTH, TRACK_COLOUR)
    filled = fill_width(percent)
    if filled:
        pill(draw, filled, FILL_COLOUR)
    return image.resize((WIDTH, HEIGHT), Image.LANCZOS)


def main():
    OUTPUT.mkdir(exist_ok=True)
    for percent in STEPS:
        render(percent).save(OUTPUT / f"progress-{percent}.png", optimize=True)


if __name__ == "__main__":
    main()
