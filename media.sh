#!/bin/sh
##########################################
##			     ƒøxglove			    ## 
##			   ƒøx-conky-v2			    ## 
##			   media script  		    ## 
##########################################

# Prints the MEDIA section for conky's ${texecpi}: 
# The first MPRIS player that is PLAYING, or nothing at all (PAUSED/STOPPED players are ignored).

# Output starts with a newline because the config joins it to the line above, so an empty result leaves no blank line.

line=$(playerctl -a metadata --format '{{status}}	{{playerName}}	{{trunc(title, 42)}}	{{trunc(artist, 42)}}	{{duration(position)}}	{{duration(mpris:length)}}' 2>/dev/null |
	grep -m1 '^Playing	')
[ -n "$line" ] || exit 0

# "$$" is a literal "$" for conky, so titles like "$uicideboy$" are not parsed
printf '%s\n' "$line" | sed 's/\$/$$/g' | awk -F'\t' '{
	player = toupper(substr($2, 1, 1)) substr($2, 2)
	time = ($6 != "") ? $5 "${color}/" $6 : $5
	printf "\n${color1}${stippled_hr}${color}\n"
	printf "${font2}${color1}[󰝚 MEDIA]${color}${alignr}%s ${color3}%s${color}${font}\n", player, time
	printf "󰎈 ${color3}%s${color}", ($3 != "") ? $3 : "Unknown title"
	if ($4 != "") printf "\n󰠃 %s", $4
}'
