import http.server
import socketserver
import json
import io
import pngconverterapi
import matplotlib
import inference
import numpy

def pngToNumpyArray2dUint8(rawPngBytes : bytes) -> numpy.ndarray:
    pngio = io.BytesIO(rawPngBytes) 
    ndarray_0_255 = matplotlib.pyplot.imread(pngio) * 255.0
    return ndarray_0_255.astype(numpy.uint8)

class DigitCheckerAppHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        self.insertHeaders404NotFound()
        self.handle404NotFound()

    def do_POST(self):
        if self.path.lower() == "/checkdigit":
            self.insertHeaders200OK()
            self.handleCheckDigit()
            return 

        self.insertHeaders404NotFound()

    def insertHeaders200OK(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

    def insertHeaders404NotFound(self):
        self.send_response(404)
        self.send_header("Content-type", "text/html")
        self.end_headers()

    def handleCheckDigit(self):
        content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
        post_data = self.rfile.read(content_length) # <--- Gets the data itself
        raw_png_bytes = post_data
        greyscale_28x28x8bit_png_bytes = pngconverterapi.pngToGreyscale28x28x8bit(raw_png_bytes)
        greyscale_28x28x8bit_array = pngToNumpyArray2dUint8(greyscale_28x28x8bit_png_bytes)
        recognized_digit = inference.checkDigit(greyscale_28x28x8bit_array)
        result = {"value" : recognized_digit}
        result_json_string = json.dumps(result)    
        self.writeString(result_json_string)

    def handle404NotFound(self):
        self.writeString("<html><head><title>404 Not Found</title></head>")
        self.writeString("<body><p>404 Not Found</p>")
        self.writeString("</body></html>")

    def writeString(self, str: str):
        bytes = bytearray(str, "UTF-8")
        self.wfile.write(bytes)


def runServer(port : int):
    with socketserver.TCPServer(("", port), DigitCheckerAppHandler) as httpd:
        print("digitchecker serving at port", port)
        httpd.serve_forever()