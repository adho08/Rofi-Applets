#!/bin/bash

THEMES_DIR="$HOME/.config/wallust/themes/"
THEME="$HOME/.config/rofi/custom/layouts/type-2.rasi"
PROMPT="Select Theme" 

# Get themes without extension for display
themes=$(find "$THEMES_DIR" -type f -exec basename {} \; | sed 's/\.[^.]*$//')
echo "Themes: $themes"

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
full_path=$(find "$THEMES_DIR" -type f -name "$selected.*" | head -1)
echo "$full_path"

if [[ -n "$full_path" ]]; then
    "$HOME"/.config/wallust/set-theme.sh "$full_path"
else
    notify-send "Error" "Wallpaper not found"
fi
