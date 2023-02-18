from http.server import BaseHTTPRequestHandler

from io import BytesIO
from matplotlib.figure import Figure
import base64


class handler(BaseHTTPRequestHandler):
    def generate_image(self):
        # Generate the figure **without using pyplot**.
        fig = Figure()
        ax = fig.subplots()
        ax.plot([1, 2])

        # Save it to a temporary buffer.
        buf = BytesIO()
        fig.savefig(buf, format="png")
        data = base64.b64encode(buf.getbuffer()).decode("ascii")
        b64img = '<img src="data:image/png;base64,{}" />'.format(
            data)
        return b64img

    def do_GET(self):
        data = self.generate_image()

        # Send our response and headers
        self.send_response(200)

        self.send_header('Content-Type', 'text/html')
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()

        self.wfile.write(data.encode())

        return
