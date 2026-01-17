#!/bin/bash

# Checks if a device is connected
device_connected() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Connected: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles device connection
toggle_connection() {
    if device_connected "$1"; then
        bluetoothctl disconnect "$1"
    else
        bluetoothctl connect "$1"
    fi
}

# Checks if a device is paired
device_paired() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Paired: yes"; then
        echo "Paired: yes"
        return 0
    else
        echo "Paired: no"
        return 1
    fi
}

# Toggles device paired state
toggle_paired() {
    if device_paired "$1"; then
        bluetoothctl remove "$1"
    else
        bluetoothctl pair "$1"
    fi
}

# Checks if a device is trusted
device_trusted() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Trusted: yes"; then
        echo "Trusted: yes"
        return 0
    else
        echo "Trusted: no"
        return 1
    fi
}

# Toggles device trust
toggle_trust() {
    if device_trusted "$1"; then
        bluetoothctl untrust "$1"
    else
        bluetoothctl trust "$1"
    fi
}

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Bluetooth device information
device="$1"
device_name=$(echo "$device" | cut -d ' ' -f 3-)
mac=$(echo "$device" | cut -d ' ' -f 2)
icon=$(bluetoothctl info "$mac" | grep "Icon:" | awk '{print $2}') # what type of device (headset, phone, ...)
battery=$(bluetoothctl info "$mac" | grep -oP 'Battery Percentage:.*\(\K[0-9]+')


# Theme Elements
PROMPT="$device_name"
MESG="Type: $icon"
if [[ ! -z $battery ]]; then
	MESG="$MESG
Battery: $battery%"
fi
# set font manually because in .rasi the font size is 40 (meant for icons)
OPTIONS_FONT="JetBrains Mono Nerd Font 12"
LIST_COL='3'
LIST_ROW='1'

# Options
if device_connected "$mac"; then
    option_1="Connected: yes"
else
    option_1="Connected: no"
fi
option_2=$(device_paired "$mac")
option_3=$(device_trusted "$mac")

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
	    	-theme-str "element-text {font: \"$OPTIONS_FONT\";}" \
		-mesg "$MESG" \
		-p "$PROMPT" \
		-theme "$THEME"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		toggle_connection "$mac"
	elif [[ "$1" == '--opt2' ]]; then
		toggle_paired "$mac"
	elif [[ "$1" == '--opt3' ]]; then
		toggle_trust "$mac"
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
