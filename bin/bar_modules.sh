#!/usr/bin/env bash

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Theme Elements
PROMPT="Modules"

LIST_COL=8
LIST_ROW=1

# CMDs (add your apps here)
bluetooth_cmd="$SCRIPT_DIR/bluetooth.sh"
audio_cmd=''
network_cmd="$SCRIPT_DIR/network.sh"
backlight_cmd="$SCRIPT_DIR/backlight.sh"
battery_cmd="$SCRIPT_DIR/battery.sh"
powermenu_cmd="$SCRIPT_DIR/powermenu.sh"
theme_cmd="$SCRIPT_DIR/theme.sh"
music_cmd="$SCRIPT_DIR/music.sh"

# Options
option_1=""  # Bluetooth
option_2="󰕾"  # Audio
option_3="󰖩 " # Wifi
option_4=""  # Brightness
option_5="󰁾"  # Battery
option_6=""  # Powermenu
option_7=" " # Powermenu
option_8=" " # Music

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
		-theme-str "window {width: 1000px;}" \
		-dmenu \
		-p "$PROMPT" \
		-markup-rows \
		-theme "$THEME"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_8" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		${bluetooth_cmd}
	elif [[ "$1" == '--opt2' ]]; then
		"${audio_cmd[@]}"
	elif [[ "$1" == '--opt3' ]]; then
		${network_cmd}
	elif [[ "$1" == '--opt4' ]]; then
		${backlight_cmd}
	elif [[ "$1" == '--opt5' ]]; then
		${battery_cmd}
	elif [[ "$1" == '--opt6' ]]; then
		${powermenu_cmd}
	elif [[ "$1" == '--opt7' ]]; then
		${theme_cmd}
	elif [[ "$1" == '--opt8' ]]; then
		${music_cmd}
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
"$option_1")
	run_cmd --opt1
	;;
"$option_2")
	run_cmd --opt2
	;;
"$option_3")
	run_cmd --opt3
	;;
"$option_4")
	run_cmd --opt4
	;;
"$option_5")
	run_cmd --opt5
	;;
"$option_6")
	run_cmd --opt6
	;;
"$option_7")
	run_cmd --opt7
	;;
"$option_8")
	run_cmd --opt8
	;;
esac
