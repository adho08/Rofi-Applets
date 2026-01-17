#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
THEME="$HOME/.config/rofi/custom/layouts/type-2.rasi"
PROMPT="Bluetooth connect" 

# Bluetooth devices information
devices=$(bluetoothctl devices | grep Device | cut -d ' ' -f 3-)

rofi_cmd() {
	rofi 	-dmenu \
		-p "$PROMPT" \
		-theme "$THEME" \
		-i
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$devices" | rofi_cmd
}

# Show rofi menu
selected=$(run_rofi)
[[ -z "$selected" ]] && exit 0

device=$(bluetoothctl devices | grep "$selected")
# Open a submenu if a device is selected
if [[ $device ]]; then bash "$SCRIPT_DIR"/bluetooth_device.sh "$device"; fi
