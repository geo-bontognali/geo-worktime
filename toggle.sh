#!/usr/bin/env bash
# Toggles worktime in its own special workspace and launches it if it isn't running.
URL="file://$HOME/repos/geo-worktime/index.html"
CMD="/opt/google/chrome/chrome --no-first-run --no-default-browser-check --allow-file-access-from-files --user-data-dir=$HOME/.chrome-proxy-profile --app=$URL"

running=$(pgrep -f 'chrome-proxy-profil[e] --app' >/dev/null && echo true)
if [ "$running" != "true" ]; then
    hyprctl dispatch "hl.dsp.exec_cmd(\"[workspace special:worktime] $CMD\")"
    # show it only if it's not already shown, so the toggle below doesn't hide it
    visible=$(hyprctl -j monitors | grep -q '"name": "special:worktime"' && echo true)
    [ "$visible" = "true" ] && exit 0
fi
hyprctl dispatch 'hl.dsp.workspace.toggle_special("worktime")'
