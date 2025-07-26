#!/bin/bash
wallpaper_dir="$HOME/Pictures/wallpapers"

random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)

hyprpaper & 
hyperctl hyprpaper preload "$random_wallpaper"
hyperctl hyprpaper wallpaper "eDP-1,$random_wallpaper"


# Update color palette
if ! wal -i "$random_wallpaper" --backend /opt/miniconda3/bin/colorz; then
	echo "Failed to generate colors with Pywal"
	exit 1
fi

while [ ! -f ~/.cache/wal/color-waybar.css ]; do
	sleep 0.1
done

pkill -f waybar || true
waybar &
