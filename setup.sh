#!/usr/bin/env bash
# Puts the Azure OpenAI endpoint/key from the wor-workframe dotnet user secrets into config.js.
# No config.js yet: starts from config.example.js. Existing config.js: only the two values are replaced.
set -euo pipefail
cd "$(dirname "$0")"
SECRETS="${1:-$HOME/.microsoft/usersecrets/22f1b2e3-92b9-41e4-ba00-d7b9f7cdac96/secrets.json}"
[ -f config.js ] || cp config.example.js config.js
python3 - "$SECRETS" <<'PY'
import json, re, sys
d = json.load(open(sys.argv[1], encoding='utf-8-sig'))
get = lambda k: d.get('AI:' + k) or d.get('AI', {}).get(k)
uri, key = get('AzureOpenAIUri'), get('AzureOpenAIKey')
if not uri or not key:
    sys.exit('secrets.json has no AI:AzureOpenAIUri / AI:AzureOpenAIKey')
src = open('config.js', encoding='utf-8').read()
esc = lambda s: s.replace('\\', '\\\\').replace("'", "\\'")
src, n1 = re.subn(r"(endpoint:\s*')[^']*(')", lambda m: m.group(1) + esc(uri) + m.group(2), src, count=1)
src, n2 = re.subn(r"(apiKey:\s*')[^']*(')", lambda m: m.group(1) + esc(key) + m.group(2), src, count=1)
if not (n1 and n2):
    sys.exit("config.js has no ai: { endpoint: '…', apiKey: '…' } block to fill; copy it from config.example.js")
open('config.js', 'w', encoding='utf-8').write(src)
print('wrote config.js')
PY
chmod 600 config.js
