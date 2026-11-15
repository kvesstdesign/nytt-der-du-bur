"""Lokal testserver for Nytt der du bur.

Serverer repoet på http://localhost:8080 og tar imot POST til /test-formResponse
(brukt når siden åpnes med ?test=1), så ingen testsvar havner i Google-skjemaet.
"""
import http.server
import os
import sys
import urllib.parse

ROT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PORT = int(os.environ.get("PORT", "8080"))


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROT, **kwargs)

    def do_POST(self):
        if self.path.split("?")[0] != "/test-formResponse":
            self.send_error(404)
            return
        n = int(self.headers.get("Content-Length") or 0)
        felt = urllib.parse.parse_qsl(self.rfile.read(n).decode("utf-8"), keep_blank_values=True)
        print("TESTSVAR", felt, flush=True)
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"ok")


if __name__ == "__main__":
    print(f"Serverer {ROT} på http://localhost:{PORT}", flush=True)
    http.server.ThreadingHTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
