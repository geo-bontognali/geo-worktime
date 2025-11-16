# Work Time Activity Monitor

A simple activity monitoring system for Hyprland that tracks active windows and idle time, displaying them in a visual timeline with Catppuccin Mocha theme.

## Overview

This project consists of two main components:

1. **Bash Script (`monitor_activity.sh`)** - Monitors your active windows and idle status
2. **HTML Dashboard (`index.html`)** - Visualizes your daily activity in a timeline

## Features

- **24-hour timeline visualization** with color-coded activity blocks
- **Date navigation** to browse through historical activity logs
- **Region selection** - Click and drag to select a time range and see:
  - Start and end time
  - Total duration
  - Active time (green blocks) within the selection
- **Activity blocks**:
  - **Green** - Active/working (window is active)
  - **Red** - Idle (no activity detected)
- **Hover tooltips** showing window title/application name
- **Catppuccin Mocha** color theme

## Setup

### Prerequisites

Make sure hypridle is configured to write idle status to `/tmp/.gtime_ipc`:

```
listener {
    timeout = 140                     
    on-timeout = echo 1 > /tmp/.gtime_ipc; 
    on-resume = echo 0 > /tmp/.gtime_ipc; 
}
```

### Running the Monitor

Add the monitor to your Hyprland config to start automatically:

```bash
# ~/.config/hypr/hyprland.conf
exec-once = ..../monitor_activity.sh
```

The script logs activity every 60 seconds by default. You can adjust the `INTERVAL` variable in the script if needed.

### Viewing the Dashboard

Add a keybind to open the dashboard in Chrome as a standalone app:

```bash
# ~/.config/hypr/hyprland.conf
bind = $mainMod, W, exec, google-chrome --allow-file-access-from-files --user-data-dir=/tmp/chrome-worktime --app=file:///..../geo-worktime/index.html
```

The dashboard will automatically load today's activity log. Use the navigation buttons to browse previous or future days.

## File Structure

```
.
├── monitor_activity.sh    # Activity monitoring script
├── index.html            # Dashboard UI
├── logs/                 # Daily activity logs
│   └── activity_log_YYYY-MM-DD.csv
└── README.md            # This file
```

## CSV Log Format

Each log file contains:
- `timestamp` - Date and time of the log entry
- `window_title` - Title of the active window
- `window_class` - Application class name
- `is_idle` - "true", "false", or "unknown"

## How It Works

The bash script runs in the background and:
- Queries `hyprctl activewindow -j` to get the current active window
- Reads idle status from `/tmp/.gtime_ipc` (set by hypridle)
- Logs data every 60 seconds to a CSV file
- Creates one log file per day in the `logs/` directory

**Log format:** `logs/activity_log_YYYY-MM-DD.csv`
