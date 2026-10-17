# geo-worktime

A single-file page (`index.html`, vanilla, no build) over the activity log that `monitor_activity.sh` writes on Hyprland
(one CSV row every 90 s: active window title, class, idle flag). It shows **for which customer you worked, how long, and
when**, so the hours can be booked per customer in AbaNinja.

## How it works

- **Timeline**: the day as one bar, from the first to the last activity, in two bands. Top: **green** = you worked,
  **amber** = the PC was on but you were idle or it was locked, **hatched** = the PC was off. Bottom: what you worked on,
  in customer colours (paler = suggested by the AI or by "between two blocks of the same customer"). `now` is red on today.
  Hover shows what was in front of you and for which customer.
- **Selection**: drag across the timeline. It snaps to block edges (`Shift` = 5-min grid, `Alt` = no snap), and you can drag
  its edges or move it. Click a block to select it, double-click to select the whole stretch the PC was on. The selection
  stays until `Esc`, is remembered per day and lives in the URL (`#2026-10-16/09:30-12:00`).
- **Summary** below: the selection (or the whole day) per customer, exact and in quarter hours, with a share bar. Click a
  customer to fade the others on the timeline. `y` copies a booking block (customer, hours, top titles).
- **Customer per title**, first hit wins: your own choice → `config.rules` → Jira key in the title (`[BET-66]`) →
  keywords from `config.js` → ignore list → AI (optional) → between two blocks of the same customer.
  To correct one: right-click the block (or hover it and press `c`), type, `Enter`. It is remembered for that title.

| key | action |
|---|---|
| ← → | previous / next day |
| t | today |
| h l / H L | select previous / next block, or extend by one |
| esc | clear the selection, then the highlight |
| c | set the customer of the block under the mouse |
| y | copy the booking block |

## Config and setup

`config.js` is optional and gitignored. Without it the page still works (timeline, selection, totals), but only configured
customers are recognised, so titles stay unassigned unless you set them, and no AI call is ever made.

- `cp config.example.js config.js` and edit customers (`code` = Jira project key, `match` = keywords or `/regex/`),
  the internal bucket, the ignore list and the AI context.
- `./setup.sh` fills the Azure OpenAI endpoint and key from the wor-workframe dotnet user secrets (the same values
  geo-corrector uses). It starts from `config.example.js` when `config.js` is missing, otherwise it only replaces the two
  values in place, and sets `chmod 600`. Remove the `ai:` block to disable the AI.
- Customers you set by hand live in the browser (`localStorage`); to make one permanent, add it to `rules` in `config.js`.

The logger needs hypridle to write the idle flag:

```
listener {
    timeout = 140
    on-timeout = echo 1 > /tmp/.gtime_ipc
    on-resume = echo 0 > /tmp/.gtime_ipc
}
```

## Hyprland

The logger starts with the session. `SUPER + SHIFT + T` runs `toggle.sh`, which pops worktime up full size in its own
special workspace (`special:worktime`) like the corrector, launching it on first use and hiding it on the next press. It runs as a
Chrome app with file access (needed to read `logs/` from `file://`) in its own profile `~/.chrome-proxy-profile`.
In `~/.config/hypr/hyprland.lua`:

```lua
hl.on("hyprland.start", function()
	hl.exec_cmd("~/repos/geo-worktime/monitor_activity.sh")
end)

hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("~/repos/geo-worktime/toggle.sh"))
```

## Files

```
index.html           dashboard (single file)
monitor_activity.sh  logger: logs/activity_log_YYYY-MM-DD.csv, one row every 90 s
config.example.js    template for config.js
setup.sh             writes the AI credentials into config.js
toggle.sh            shows / hides the page (SUPER + SHIFT + T)
logs/                CSV logs (gitignored)
config.js            your config incl. API key (gitignored)
```

The repo is public: `logs/` and `config.js` are gitignored on purpose, keep them that way.
