#!/bin/bash

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Backlight information
brightness="$(brightnessctl -m | cut -d',' -f4 | tr -d '%')"

if [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
	monitor="$(hyprctl monitors | grep Monitor | awk '{print $2}')"
else
	monitor="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
fi

kdb_backlight="$(brightnessctl --device='*kbd_backlight' -m | cut -d',' -f4 | tr -d '%')"
temperature=$(pgrep -a gammastep | grep -oP '\-O \K[0-9]+')

if [[ -n "$temperature" ]]; then
    filter_percent=$(bc <<< "scale=0; (6500 - $temperature) * 100 / 6500")
    bluelight_filter="${filter_percent}"
else
    bluelight_filter="0"
fi

# Theme Elements
PROMPT="Backlight"
MESG="Monitor ($monitor): $brightness%
Keyboard: $kdb_backlight%
Blue light: $bluelight_filter%"

LIST_COL='3'
LIST_ROW='1'

# Commands
if [[ "$bluelight_filter" -ge 50 ]]; then
	# Reset blue light filter to 0% (6500K)
	bluelight_filter="6500"
else
	# Set it to 50% (3250K)
	bluelight_filter="3250"
fi


if [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
	set_bluelight_filter="pkill hyprsunset; hyprsunset -t $bluelight_filter &"
else
	set_bluelight_filter="pkill gammastep; gammastep -O $bluelight_filter &"
fi

if [[ "$(brightnessctl --device='*kbd_backlight' -m | cut -d',' -f4 | tr -d '%')" -ge 50 ]]; then
	set_kdb_backlight="brightnessctl --device='*kbd_backlight' set 0"
else
	set_kdb_backlight="brightnessctl --device='*kbd_backlight' set 2"
fi

open_settings_gui="wdisplays"

# Options
option_1=''
option_2=' '
option_3=' '

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
	# use bash -c because set_bluelight_filter are multiple commands
	if [[ "$1" == '--opt1' ]]; then
		bash -c "$set_bluelight_filter"
	elif [[ "$1" == '--opt2' ]]; then
		brightnessctl --device='*kbd_backlight' set 0
		bash -c "$set_kdb_backlight"
	elif [[ "$1" == '--opt3' ]]; then
		"$open_settings_gui"
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
esac

