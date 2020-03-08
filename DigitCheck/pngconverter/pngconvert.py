from PIL import Image
import PIL.ImageOps   
import io


def pngToGreyscale28x28x8bit(raw_png_bytes : bytes) -> bytes:
    LUMINOSITY = 'L'
    IMG_SIZE = 28

    pngio = io.BytesIO(raw_png_bytes)
    img = Image.open(pngio).convert(LUMINOSITY)
    img.thumbnail((IMG_SIZE, IMG_SIZE), PIL.Image.BOX)
    converted_png_bytesio = io.BytesIO()
    img.save(converted_png_bytesio, format="png")
    return converted_png_bytesio.getvalue()
