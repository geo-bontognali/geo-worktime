# Work Time Activity Monitor

A simple activity monitoring system for Hyprland that tracks active windows and idle time, displaying them in a visual timeline.

## Overview

This project consists of two main components:

1. **Bash Script (`monitor_activity.sh`)** - Monitors your active windows and idle status
2. **HTML Dashboard (`index.html`)** - Visualizes your daily activity in a timeline

## How It Works

### Activity Monitoring

The bash script runs in the background and:
- Queries `hyprctl activewindow -j` to get the current active window
- Reads idle status from `/tmp/.gtime_ipc` (set by hypridle)
- Logs data every 10 seconds (configurable) to a CSV file
- Creates one log file per day in the `logs/` directory

**Log format:** `logs/activity_log_YYYY-MM-DD.csv`

### Visual Timeline

The HTML dashboard displays:
- A horizontal bar representing 24 hours
- Colored blocks for each activity:
  - **Green** - Active/working (window is active)
  - **Red** - Idle (no activity detected)
- Hover over any block to see the window title/application name
- Time labels every 2 hours below the timeline

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

Start the activity monitor:

```bash
./monitor_activity.sh
```

This will run continuously and log your activity. Press `Ctrl+C` to stop.

**Production settings:** Change `INTERVAL=10` to `INTERVAL=60` in the script to log every minute instead of every 10 seconds.

### Viewing the Dashboard

Open the dashboard in Chrome as a standalone app:

```bash
chrome --allow-file-access-from-files --user-data-dir=/tmp/chrome-dev --app=file:////home/geo/repos/wor_worktime/index.html
```

The dashboard will automatically load today's activity log and display it on the timeline.

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

## Future Enhancements

- Date picker to view historical data
- Activity statistics and summaries
- Export reports
- Filter by application type
