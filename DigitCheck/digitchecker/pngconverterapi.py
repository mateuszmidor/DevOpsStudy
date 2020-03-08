import requests 

def pngToGreyscale28x28x8bit(raw_png_bytes : bytes) -> bytes:
    # localhost (digitchecker and pngconverter are running in the same POD so under same localhost)
    ip = "127.0.0.1"
    port = "81"
    API_ENDPOINT = "http://{}:{}/convertpng".format(ip, port)
    try:
        # try adjust input
        r = requests.post(url = API_ENDPOINT, data = raw_png_bytes)
        converted_png_bytes = r.content
        return converted_png_bytes
    except:
        # try with originial input
        print("Warning: pngconverter service not available. Using original PNG image")
        return raw_png_bytes
