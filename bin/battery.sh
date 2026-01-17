#!/bin/bash

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Battey information
battery="$(acpi -b | cut -d',' -f1 | cut -d':' -f1)"
status="$(acpi -b | cut -d',' -f1 | cut -d':' -f2 | tr -d ' ')"
percentage="$(acpi -b | cut -d',' -f2 | tr -d ' ',%)"
time="$(acpi -b | cut -d',' -f3)"

# Theme Elements
PROMPT='Battery'
MESG="${battery}: ${percentage}%,${time}"

LIST_COL='2'
LIST_ROW='1'

# CMDs (add your apps here)
change_powerprofile="$HOME/.config/rofi/custom/bin/battery_powerprofile.sh"
open_settings_gui='gnome-power-statistics'

# Options
option_1='󰠠 '
option_2=' '

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
	echo -e "$option_1\n$option_2" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		${change_powerprofile}
	elif [[ "$1" == '--opt2' ]]; then
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
esac

