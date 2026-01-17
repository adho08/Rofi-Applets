#!/usr/bin/env bash

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Theme Elements
PROMPT='Waybar Modules'

LIST_COL='6'
LIST_ROW='1'

# CMDs (add your apps here)
bluetooth_cmd="rofi-bluetooth"
audio_cmd=''
network_cmd="$HOME/.config/rofi/custom/bin/network.sh"
backlight_cmd="$HOME/.config/rofi/custom/bin/backlight.sh"
battery_cmd="$HOME/.config/rofi/custom/bin/battery.sh"
powermenu_cmd="$HOME/.config/rofi/custom/bin/powermenu.sh"

# Options   
option_1="" # Bluetooth
option_2="󰕾" # Audio
option_3="󰖩 " # Wifi
option_4="" # Brightness
option_5="󰁾" # Battery
option_6="" # Powermenu


# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
		-theme-str 'textbox-prompt-colon {str: "Polybar";}' \
		-dmenu \
		-p "$PROMPT" \
		-markup-rows \
		-theme ${THEME}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
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
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
esac

