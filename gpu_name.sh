#!/bin/sh
##########################################
##			     ƒøxglove			    ## 
##			   ƒøx-conky-v2			    ## 
##			  gpu name script		    ## 
##########################################

# Usage: gpu_name.sh [drm card, default card1]

# Prints the GPU's marketing name for conky's GPU header.
# AMD: exact name from libdrm's amdgpu.ids (PCI device + revision).
# Otherwise: the bracketed name from lspci, e.g. "Radeon RX 9070/9070 XT/9070 GRE".

# Note: i don't have 20-something GPUs around to accurately test this, so it might not work.

dev=/sys/class/drm/${1:-card1}/device
id=$(sed 's/^0x//' "$dev/device" 2>/dev/null)
rev=$(sed 's/^0x//' "$dev/revision" 2>/dev/null)

name=$(awk -F',\t' -v id="$id" -v rev="$rev" '
	toupper($1) == toupper(id) && toupper($2) == toupper(rev) { print $3; exit }
' /usr/share/libdrm/amdgpu.ids 2>/dev/null)

if [ -z "$name" ]; then
	slot=$(basename "$(readlink -f "$dev")")
	name=$(lspci -s "$slot" -vmm 2>/dev/null | awk -F'\t' '/^Device:/ { print $2 }')
	case $name in *\[*\]*) name=${name#*\[}; name=${name%\]*} ;; esac
fi

name=${name#AMD }
echo "${name:-GPU}"
