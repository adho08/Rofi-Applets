#!/bin/bash

# Import Current Theme
DIR="$HOME/.config/rofi/custom/bin"
THEME="$DIR/../layouts/type-1.rasi"

# Theme information

# Theme Elements
PROMPT="Set Theme and/or Wallpaper"
MESG="Theme: " # TODO: display current theme

LIST_COL='3'
LIST_ROW='1'

# CMDs (add your apps here)
select_wallpaper_and_theme="$HOME/.config/rofi/custom/bin/theme-wallpaper_list.sh"
select_wallpaper="$HOME/.config/rofi/custom/bin/wallpaper_list.sh"
select_theme="$HOME/.config/rofi/custom/bin/theme_list.sh"

# Options
option_1='  +  '
option_2=' '
option_3=' '

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $LIST_COL; lines: $LIST_ROW;}" \
		-theme-str "window {width: 800px;}" \
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
	if [[ "$1" == '--opt1' ]]; then
		${select_wallpaper_and_theme}
	elif [[ "$1" == '--opt2' ]]; then
		${select_wallpaper}
	elif [[ "$1" == '--opt3' ]]; then
		${select_theme}
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

