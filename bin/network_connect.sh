#!/bin/bash
export XCURSOR_SIZE=24
export XCURSOR_THEME="Adwaita"

THEME="$HOME/.config/rofi/custom/layouts/type-2.rasi"
PROMPT="Select Wifi Network" 

# Get list of WiFi networks
get_wifi_networks() {
    nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | \
    awk -F: '!seen[$1]++ {printf "%s:%s:%s\n", $1, $2, $3}'
}

# Format for rofi display
format_networks() {
    ssids=""
    while IFS=: read -r ssid signal security; do
        [[ -z "$ssid" ]] && continue
	ssids+="$ssid\n"
    done

    # Delete the last \n
    ssids="${ssids:0:-2}"

    echo -e "$ssids"
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
	get_wifi_networks | format_networks | rofi_cmd
}

# Show rofi menu
selected=$(run_rofi)
[[ -z "$selected" ]] && exit 0

# Extract SSID from selection (everything after signal bar and lock icon)
ssid="$selected"

# Check if password is needed
security=$(nmcli -t -f SSID,SECURITY device wifi list |
    awk -F: -v s="$ssid" '$1 == s {print $2; exit}')

# Check if network is already stored 
network_stored=$(nmcli -t -f NAME,TYPE connection show | \
    awk -F: '$2=="802-11-wireless"{print $1}' | grep -Fx "$ssid")

if [[ "$security" != "--" ]]; then
    # Secured network

    if [[ -n "$network_stored" ]]; then
        # Try stored credentials first (GUI agent may appear if needed)
        if nmcli connection up "$ssid"; then
            exit 0
        fi
    fi

    # Either no stored connection or it failed
    # Let NetworkManager ask via GUI agent
    nmcli dev wifi connect "$ssid"

else
    # Open network
    nmcli device wifi connect "$ssid"
fi

# Show result if failed
if [[ $? != 0 ]]; then
    rofi -e "Failed to connect to $ssid"
fi
