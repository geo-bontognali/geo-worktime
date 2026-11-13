#!/usr/bin/env python3
"""Serves geo-worktime on 127.0.0.1 and saves what the page assigns, as plain files next to the logs:

    logs/assign_YYYY-MM-DD.json   ranges of that day set by hand: [{"from": "10:27:13", "to": "13:47:00", "code": "WSF"}]
    customers.json                customer codes created from the page: [{"code": "ABC", "name": "Acme"}]

Only these two kinds of file can be written. Requests must come from the page itself: the Host has to be this server
(no DNS rebinding) and a write needs the X-Worktime header, which a foreign web page cannot send without a CORS
preflight that this server never answers.
"""
import json
import os
import re
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

ROOT = os.path.dirname(os.path.abspath(__file__))
PORT = int(os.environ.get('WORKTIME_PORT', '47123'))
HOSTS = {f'127.0.0.1:{PORT}', f'localhost:{PORT}'}
WRITABLE = re.compile(r'^/(logs/assign_\d{4}-\d\d-\d\d\.json|customers\.json)$')


class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

    def _allowed(self):
        origin = self.headers.get('Origin')
        return self.headers.get('Host') in HOSTS and (origin is None or origin.split('://', 1)[-1] in HOSTS)

    def do_GET(self):
        if not self._allowed():
            return self.send_error(403)
        if any(p.startswith('.') for p in self.path.split('?', 1)[0].split('/') if p):   # .git, .gitignore …
            return self.send_error(404)
        super().do_GET()

    def do_HEAD(self):
        self.do_GET()

    def do_PUT(self):
        if not self._allowed() or self.headers.get('X-Worktime') != '1':
            return self.send_error(403)
        m = WRITABLE.match(self.path)
        if not m:
            return self.send_error(404)
        n = int(self.headers.get('Content-Length') or 0)
        if n > 1_000_000:
            return self.send_error(413)
        try:
            data = json.loads(self.rfile.read(n))
        except ValueError:
            return self.send_error(400, 'not json')
        if not isinstance(data, list) or not all(isinstance(x, dict) for x in data):
            return self.send_error(400, 'expected a list of objects')
        path = os.path.join(ROOT, m.group(1))
        os.makedirs(os.path.dirname(path), exist_ok=True)
        tmp = path + '.tmp'
        with open(tmp, 'w', encoding='utf-8') as f:   # one entry per line: easy to read and to edit by hand
            f.write('[\n' + ',\n'.join('  ' + json.dumps(x, ensure_ascii=False) for x in data) + ('\n' if data else '') + ']\n')
        os.replace(tmp, path)
        self.send_response(204)
        self.end_headers()

    def log_message(self, *args):
        pass


if __name__ == '__main__':
    ThreadingHTTPServer(('127.0.0.1', PORT), partial(Handler, directory=ROOT)).serve_forever()
