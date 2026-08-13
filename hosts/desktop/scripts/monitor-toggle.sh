#!/usr/bin/env bash

# Check if HDMI-A-2 is currently enabled
if kscreen-doctor -o | grep -A 1 "HDMI-A-2" | grep -q "enabled"; then
    # It's on: Turn it off, force DP-1 to stay at the origin (0,0) as primary
    kscreen-doctor output.DP-1.enable output.DP-1.primary output.DP-1.position.0,0 output.HDMI-A-2.disable
else
    # It's off: Turn it on, put DP-1 at (0,0) and place HDMI-A-2 to its right at (1920,0)
    kscreen-doctor output.DP-1.enable output.DP-1.primary output.DP-1.position.0,0 output.HDMI-A-2.enable output.HDMI-A-2.position.2560,300
fi
