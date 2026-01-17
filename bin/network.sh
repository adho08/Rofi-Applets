#!/bin/bash

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Network information
ssid_connected=$(iwgetid -r)
signal="$(nmcli -f IN-USE,SIGNAL dev wifi | grep '\*' | awk '{print $2}')"
interface=$(nmcli -t -f DEVICE connection show --active | head -n1)
ip_addr=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Theme Elements
PROMPT="Network"
MESG="$ssid_connected: $signal%, $ip_addr"
LIST_COL='3'
LIST_ROW='1'

# Commands
connect_cmd="$HOME/.config/rofi/custom/bin/network_connect.sh"

if [[ "$(nmcli radio wifi)" == "enabled" ]]; then
    toggle_wifi_cmd="nmcli radio wifi off"
else
    toggle_wifi_cmd="nmcli radio wifi on"
fi

open_settings_gui='nm-connection-editor'

# Options
option_1="  " # Connect

wifi_status=$(nmcli radio wifi)
if [[ "$wifi_status" == "enabled" ]] ; then
    option_2="󰖪 " # Wifi off/on
else
    option_2="󰖩 " # Wifi off/on
fi

option_3=" "

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
		-dmenu \
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
		${connect_cmd}
	elif [[ "$1" == '--opt2' ]]; then
		${toggle_wifi_cmd}
	elif [[ "$1" == '--opt3' ]]; then
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
esac
