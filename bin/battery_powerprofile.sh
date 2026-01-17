#!/bin/bash

THEME="$HOME/.config/rofi/custom/layouts/type-2.rasi"
PROMPT="Select Power Profile" 

option_1='  Power-Saver'
option_2='󰊚  Balanced'
option_3='󰓅  Performance'

case "$(powerprofilesctl get)" in
	'power-saver')
	    option_1+='*'
		;;
	'balanced')
	    option_2+='*'
		;;
	'performance')
	    option_3+='*'
		;;
esac

# Get list of WiFi networks
get_power_profiles() {
        echo -e "$option_1\n$option_2\n$option_3"
}

rofi_cmd() {
	rofi 	-dmenu \
		-p "$PROMPT" \
		-markup-rows \
		-theme "$THEME" \
		-i
}

# Pass variables to rofi dmenu
run_rofi() {
	get_power_profiles | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		powerprofilesctl set power-saver
	elif [[ "$1" == '--opt2' ]]; then
		powerprofilesctl set balanced
	elif [[ "$1" == '--opt3' ]]; then
		powerprofilesctl set performance
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
