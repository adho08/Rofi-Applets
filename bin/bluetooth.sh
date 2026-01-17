#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Bluetooth information
bluetooth_enabled=$(bluetoothctl show | grep -q "Powered: yes" && echo "yes" || echo "no")
devices_connected=$(bluetoothctl devices Connected | cut -d ' ' -f 3-)
if [[ -z "$devices_connected" ]] ; then
    devices_connected="None"
fi

# Theme Elements
PROMPT="Bluetooth"
MESG="Connected: $devices_connected"
LIST_COL='4'
LIST_ROW='1'

# Commands
list_devices="$SCRIPT_DIR/bluetooth_list.sh"
scan() {
    bluetoothctl --timeout 5 scan on
    "$list_devices"
}

if [[ "$bluetooth_enabled" == "yes" ]]; then
    toggle_bluetooth_status="bluetoothctl power off"
else
    toggle_bluetooth_status="bluetoothctl power on"
fi

open_settings_gui="blueman-manager"

# Options
option_1=" " # List paired/known devices
option_2="󱉶" # Scan available devices

if [[ "$bluetooth_enabled" == "yes" ]] ; then
    option_3="󰂲" # Wifi off
else
    option_3="" # Wifi on
fi

option_4=" "

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
		-dmenu \
		-mesg "$MESG" \
		-p "$PROMPT" \
		-theme "$THEME" \
		-markup-rows \
		-i
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		${list_devices}
	elif [[ "$1" == '--opt2' ]]; then
		scan
	elif [[ "$1" == '--opt3' ]]; then
		${toggle_bluetooth_status}
	elif [[ "$1" == '--opt4' ]]; then
		${open_settings_gui}
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
esac
