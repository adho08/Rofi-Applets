#!/bin/bash

WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"
THEME="$HOME/.config/rofi/custom/layouts/type-2.rasi"
PROMPT="Select Wallpaper and Theme" 

# Get themes without extension for display
themes=$(find "$WALLPAPERS_DIR" -type f -exec basename {} \; | sed 's/\.[^.]*$//')

rofi_cmd() {
	rofi 	-dmenu \
		-p "$PROMPT" \
		-theme "$THEME" \
		-i
}

run_rofi() {
	echo -e "$themes" | rofi_cmd
}

selected=$(run_rofi)
[[ -z "$selected" ]] && exit 0

# Find the full path with extension
full_path=$(find "$WALLPAPERS_DIR" -type f -name "$selected.*" | head -1)

if [[ -n "$full_path" ]]; then
    bash -c "$HOME/.config/wallust/set-colors.sh '$full_path'"
else
    notify-send "Error" "Wallpaper not found"
fi
