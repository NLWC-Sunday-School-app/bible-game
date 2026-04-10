#!/bin/bash
cd "$(dirname "$0")/build/web" && python3 -c "
import http.server, socketserver
handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(('', 8080), handler) as httpd:
    print('Serving on http://localhost:8080')
    httpd.serve_forever()
"
