#!/bin/bash
# Defines important file paths
wallpaper_dir="$HOME/Pictures/wallpapers"
hyprlock_colors="$HOME/.config/hypr/hyprlock.colors"
waybar_css="$HOME/.config/waybar/colors.css"

# Selects a random wallpaper 
random_wallpaper=$(find "$wallpaper_dir" -type f | shuf -n 1)

# Copies random wallpaper into a file called current_wallpaper
cp "$random_wallpaper" "$HOME/Pictures/current_wallpaper"

# Kill and then restarts hyprpaper
killall -q hyprpaper

hyprpaper &

# hyprctl hyprpaper preload "$random_wallpaper"
# hyprctl hyprpaper wallpaper "eDP-1,$random_wallpaper"

# Update color palette 
if ! wal -i "$random_wallpaper" --backend /opt/miniconda3/bin/colorz; then
	echo "Failed to generate colors with Pywal"
	exit 1
fi

while [ ! -f /home/nephesora/.cache/wal/colors-waybar.css ]; do
	sleep 0.1
done

# Kill and restarts waybar
killall -q waybar 

waybar &

# Generate Hyprlock color variables
cat > "$hyprlock_colors" <<EOF
# Auto-generated from Pywal ($(date))
\$base = $(jq -r '"rgb(" + .special.background + ")"' ~/.cache/wal/colors.json)
\$accent = $(jq -r '"rgb(" + .colors.color1 + ")"' ~/.cache/wal/colors.json)
\$red = $(jq -r '"rgb(" + .colors.color9 + ")"' ~/.cache/wal/colors.json)
\$yellow = $(jq -r '"rgb(" + .colors.color3 + ")"' ~/.cache/wal/colors.json)
\$text = $(jq -r '"rgb(" + .foreground + ")"' ~/.cache/wal/colors.json)
EOF
