# geo-worktime

A single-file page (`index.html`, vanilla, no build) over the activity log that `monitor_activity.sh` writes on Hyprland
(one CSV row every 90 s: active window title, class, idle flag). It shows **for which customer you worked, how long, and
when**, so the hours can be booked per customer in AbaNinja.

## How it works

- **Timeline**: the day as one bar, from the first to the last activity, in two bands. Top: **green** = you worked,
  **amber** = the PC was on but you were idle or it was locked, **hatched** = the PC was off. Bottom: what you worked on,
  in customer colours (grey = `?`). `now` is red on today.
  Hover shows what was in front of you and for which customer.
- **Selection**: drag across the timeline; every drag draws a new selection, even inside the current one. It snaps to
  block edges (`Shift` = 5-min grid, `Alt` = no snap). Click a block to select it; double-click or `Esc` clears the
  selection. It is remembered per day and lives in the URL (`#2026-10-16/09:30-12:00`).
- **Figures** under the timeline, in large type: total, active and inactive for the selection, and the same for the whole day.
- **Mosaic** below: the selection (or the whole day) per customer, one tile each, its area = active time, labelled with
  the time exact and in quarter hours (hover any tile, even a tiny one, for all of it). Click a tile to fade the other
  customers on the timeline. `y` copies a booking block (customer, hours, top titles).
- **Customer**: a known customer code in the window title, as a word of its own in capitals (`[WSF-662] …`,
  `BET Bettermann - Backlog - Jira`, `Chat | SQB - …`). What follows counts for that customer until another code shows
  up, for at most 2 h after the code was last seen. The rest is `?`. Each customer keeps its colour, every day.
- **Assign by hand**: right-click the timeline to assign the selection (or the block under the pointer) to a customer.
  Type to filter, `Enter` to assign; type a new code (`ABC` or `ABC Acme AG`) to create a customer, `?` marks a range as
  no customer, `↺` gives it back to the window titles. A hand-set range beats the titles and is saved on disk
  (see below), not in the browser.

| key | action |
|---|---|
| ← → | previous / next day |
| t | today |
| h l / H L | select previous / next block, or extend by one |
| esc | clear the selection, then the highlight (double-click also clears) |
| y | copy the booking block |

## Config

`config.js` is optional and gitignored. Without it the page still works (timeline, selection, totals), but every worked
minute is `?`. `cp config.example.js config.js` and list the customers: `code` (Jira project key), `name`, `color`
(Catppuccin name or hex). Only listed codes count, so other capitals in titles (MDA, ERD, API) never become customers.

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
Chrome app in its own profile `~/.chrome-proxy-profile`, served by `serve.py` on `http://127.0.0.1:47123` (toggle.sh
starts it if it isn't running; `WORKTIME_PORT` changes the port). The server only listens on 127.0.0.1 and can only
write the two files below.
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
toggle.sh            shows / hides the page (SUPER + SHIFT + T), starts serve.py
serve.py             serves the page on 127.0.0.1 and saves what you assign
logs/                CSV logs + assign_YYYY-MM-DD.json, the ranges you assigned that day (gitignored)
config.js            your customer list (gitignored)
customers.json       customers created from the page: code, name, colour (gitignored)
```

The repo is public: `logs/`, `config.js` and `customers.json` are gitignored on purpose, keep them that way.
