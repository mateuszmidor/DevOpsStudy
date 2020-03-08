import http.server
import socketserver
import typing
import pngconvert


class ConvertPngHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        self.insertHeaders404NotFound()
        self.handle404NotFound()

    def do_POST(self):
        if self.path.lower() == "/convertpng":
            self.insertHeaders200OK()
            self.handleConvertPng()
            return 

        self.insertHeaders404NotFound()

    def insertHeaders200OK(self):
        self.send_response(200)
        self.send_header("Content-type", "application/octet-stream")
        self.end_headers()

    def insertHeaders404NotFound(self):
        self.send_response(404)
        self.send_header("Content-type", "text/html")
        self.end_headers()

    def handleConvertPng(self):
        # incoming data is raw png bytes
        content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
        raw_png_bytes = self.rfile.read(content_length) # <--- Gets the data itself
        converted_png_bytes = pngconvert.pngToGreyscale28x28x8bit(raw_png_bytes)
        self.wfile.write(converted_png_bytes)

    def handle404NotFound(self):
        self.writeString("<html><head><title>404 Not Found</title></head>")
        self.writeString("<body><p>404 Not Found</p>")
        self.writeString("</body></html>")

    def writeString(self, str: str):
        bytes = bytearray(str, "UTF-8")
        self.wfile.write(bytes)


def runServer(port : int):
    with socketserver.TCPServer(("", port), ConvertPngHandler) as httpd:
        print("pngconverter serving at port", port)
        httpd.serve_forever()