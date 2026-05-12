#!/bin/bash

# Music information
title="$(playerctl metadata title 2>/dev/null || echo 'No title')"
artist="$(playerctl metadata artist 2>/dev/null || echo 'No artist')"
player="$(playerctl metadata playerName 2>/dev/null || echo 'No player')"
status="$(playerctl status 2>/dev/null || echo 'Stopped')"

case "$1" in
--active)
	if [[ "$status" = "Playing" ]] || [[ "$status" = "Paused" ]]; then
		echo "True"
	else
		echo "False"
	fi
	exit 0
	;;
--inactive)
	if [[ "$status" = "Stopped" ]] || [[ -z "$status" ]]; then
		echo "True"
	else
		echo "False"
	fi
	exit 0
	;;
--status)
	echo "$status"
	exit 0
	;;
esac

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Theme Elements
PROMPT="Music"
MESG="Title: $title
Artist: $artist
Status: $status"
LIST_COL='3'
LIST_ROW='1'

# Options
option_1='󰒮'
if [[ "$status" = "Playing" ]]; then
	option_2='󰏤'
else
	option_2='󰐊'
fi
option_3='󰒭'

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
		-dmenu \
		-mesg "$MESG" \
		-p "$PROMPT" \
		-markup-rows \
		-theme "$THEME"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

# Execute Command
run_cmd() {
	case "$1" in
	--opt1)
		playerctl previous
		;;
	--opt2)
		playerctl play-pause
		;;
	--opt3)
		playerctl next
		;;
	esac
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
esac
