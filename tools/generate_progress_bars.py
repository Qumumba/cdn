from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

TRACK_COLOUR = "#3F3F46"
FILL_COLOUR = "#C27AFF"
LABEL_COLOUR = "#F4F4F5"
BAR_WIDTH = 400
HEIGHT = 20
RADIUS = 10
MIN_FILL = 20
LABEL_GAP = 8
LABEL_SIZE = 14
SCALE = 4
STEPS = range(0, 101)
TOOLS = Path(__file__).resolve().parent
FONT = TOOLS / "fonts" / "Inter-Bold.ttf"
OUTPUT = TOOLS.parent / "progress"


def fill_width(percent):
    if percent <= 0:
        return 0
    return max(MIN_FILL, round(BAR_WIDTH * min(percent, 100) / 100))


def label_font():
    return ImageFont.truetype(str(FONT), LABEL_SIZE * SCALE)


def canvas_width(font):
    return BAR_WIDTH + LABEL_GAP + -(-round(font.getlength("100%")) // SCALE)


def render(percent, font, width):
    image = Image.new("RGBA", (width * SCALE, HEIGHT * SCALE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    radius = RADIUS * SCALE
    bottom = HEIGHT * SCALE - 1
    draw.rounded_rectangle((0, 0, BAR_WIDTH * SCALE - 1, bottom), radius, fill=TRACK_COLOUR)
    filled = fill_width(percent)
    if filled:
        draw.rounded_rectangle((0, 0, filled * SCALE - 1, bottom), radius, fill=FILL_COLOUR)
    label_x = (BAR_WIDTH + LABEL_GAP) * SCALE
    draw.text((label_x, HEIGHT * SCALE / 2), f"{percent}%", font=font, fill=LABEL_COLOUR, anchor="lm")
    return image.resize((width, HEIGHT), Image.LANCZOS)


def main():
    OUTPUT.mkdir(exist_ok=True)
    font = label_font()
    width = canvas_width(font)
    for percent in STEPS:
        render(percent, font, width).save(OUTPUT / f"progress-{percent}.png", optimize=True)


if __name__ == "__main__":
    main()
