#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
THEME="$HOME/.config/rofi/custom/layouts/launcher.rasi"
PROMPT="App Launcher" 
LIST_COL='4'
LIST_ROW='3'

rofi_cmd() {
	rofi 	-show drun \
		-p "$PROMPT" \
		-theme "$THEME" \
		-i \
		-theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" 
}

# Pass variables to rofi dmenu
run_rofi() {
	rofi_cmd
}

run_rofi
