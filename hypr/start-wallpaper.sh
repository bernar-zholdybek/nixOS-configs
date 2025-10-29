#!/usr/bin/env bash
# Wait a few seconds for Hyprland to initialize
sleep 2
# Run mpvpaper on your monitor
mpvpaper -o "loop --no-osd-bar --keep-open=yes --hwdec=yes" eDP-1 /home/bernar/Downloads/power.mp4 &
