#!/bin/sh
##########################################
##			     ƒøxglove			    ## 
##			   ƒøx-conky-v2			    ## 
##			  weather script		    ## 
##########################################

# Usage: weather.sh <location>

# Prints wttr.in format 4 for conky's ${texecpi}.
# Conky's Xft text has no per-glyph font fallback, so emoji are wrapped in an explicit monochrome font switch (${font} resets to the default font).
# Plain "Noto Emoji" matches Noto Color Emoji and conky drops :color=false, so use a weight-specific family that only the monochrome font has.

out=$(curl -s "wttr.in/$1?format=4")
if [ "$out" = "weather data source not available" ]; then
	echo " Unavailable"
	exit
fi

# Drop U+FE0F, trim, swap wttr's emoji for the 'filled' weather glyphs in Hack Nerd Font, then wrap any leftover 4byte UTF-8 chars and U+2600-27BF (like ✨) in the emoji font

line=$(printf '%s\n' "$out" | LC_ALL=C sed 's/\xef\xb8\x8f//g' | cut -c1-35 |
	LC_ALL=C sed -e 's/☀/󰖙/g' -e 's/🌤\|⛅\|🌥/󰖕/g' -e 's/☁/󰖐/g' \
		-e 's/🌫/󰖑/g' -e 's/🌧/󰖗/g' -e 's/🌦/󰼳/g' -e 's/❄/󰼶/g' \
		-e 's/🌨/󰖘/g' -e 's/🌩/󰖓/g' -e 's/⛈/󰙾/g' -e 's/🌡/󰔏/g' -e 's/🌬/󰖝/g' |
	LC_ALL=C sed 's/\xf0[\x80-\xbf][\x80-\xbf][\x80-\xbf]\|\xe2[\x98-\x9e][\x80-\xbf]/${font Noto Emoji Medium:size=10}&${font}/g')

echo "$line"
