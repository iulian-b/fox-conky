#!/bin/sh
##########################################
##			     ƒøxglove			    ## 
##			   ƒøx-conky-v2			    ## 
##			  network script		    ## 
##########################################

# Prints the active NetworkManager connection name and a type icon for the NET header:
# 󰖩 Wi-Fi
#  ethernet
#  no connection / no internet (limited, captive portal)
# "unknown" connectivity (NetworkManager's check disabled) counts as online.

c=$(nmcli -t networking connectivity 2>/dev/null)
nmcli -t -f TYPE,STATE,CONNECTION device 2>/dev/null | awk -F: -v c="$c" '
	$2 ~ /^connected/ && ($1 == "wifi" || $1 == "ethernet") {
		n = $0; sub(/^[^:]*:[^:]*:/, "", n); gsub(/\\:/, ":", n); t = $1; exit
	}
	END { print n, (t == "" || c ~ /^(none|limited|portal)$/ ? "" : t == "wifi" ? "󰖩" : "") }'
