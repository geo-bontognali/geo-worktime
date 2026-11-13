#!/usr/bin/env bash
# Toggles worktime in its own special workspace and launches it if it isn't running.
# The page is served by serve.py on 127.0.0.1 (started here if needed), which also saves what you assign.
DIR="$(cd "$(dirname "$0")" && pwd)"
PORT="${WORKTIME_PORT:-47123}"
URL="http://127.0.0.1:$PORT/index.html"
CMD="/opt/google/chrome/chrome --no-first-run --no-default-browser-check --user-data-dir=$HOME/.chrome-proxy-profile --app=$URL"

if ! pgrep -f 'geo-worktime/serve\.py' >/dev/null; then
    setsid python3 "$DIR/serve.py" >/dev/null 2>&1 < /dev/null &
    for _ in $(seq 20); do (echo > "/dev/tcp/127.0.0.1/$PORT") 2>/dev/null && break; sleep 0.1; done
fi

running=$(pgrep -f 'chrome-proxy-profil[e] --app' >/dev/null && echo true)
if [ "$running" != "true" ]; then
    hyprctl dispatch "hl.dsp.exec_cmd(\"[workspace special:worktime] $CMD\")"
    # show it only if it's not already shown, so the toggle below doesn't hide it
    visible=$(hyprctl -j monitors | grep -q '"name": "special:worktime"' && echo true)
    [ "$visible" = "true" ] && exit 0
fi
hyprctl dispatch 'hl.dsp.workspace.toggle_special("worktime")'
