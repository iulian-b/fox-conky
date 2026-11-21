#!/bin/sh
##########################################
##			     ƒøxglove			    ## 
##			   ƒøx-conky-v2			    ## 
##			  storage script		    ## 
##########################################

# Disclosure: entirelty done with Claude Code, i do not know nor do i want to know how it works.
# I personally tried various ways in the past (made by me, or other people online). This one seems to just work, so i'll just cloe mu eyes and move on.
# Below is the original, unaltered CC script description.



# Prints the STORAGE section for conky's ${texecpi}, grouped into:
#   Internal Linux    mounted filesystems on internal disks (one row per filesystem)
#   Internal Windows  NTFS/BitLocker partitions on internal disks
#   External Drive    USB disks that are not removable media (e.g. portable HDDs)
#   External USB      removable media: flash drives, SD cards
# Partitions under 1 GiB (EFI, MSR, recovery, VTOYEFI) and swap are skipped.
# Unmounted partitions are listed as offline; empty categories show one offline line.

lsblk -P -b -o NAME,PKNAME,TYPE,TRAN,RM,SIZE,FSTYPE,LABEL,MOUNTPOINTS 2>/dev/null | awk '
function val(key,   m) {
	if (match($0, key "=\"[^\"]*\"")) return substr($0, RSTART + length(key) + 2, RLENGTH - length(key) - 3)
	return ""
}
function row(cat, name, mp) {
	name = substr(name, 1, 13)
	if (mp == "")
		out[cat] = out[cat] sprintf("%-14s[󱁌 Offline]\n", name)
	else
		out[cat] = out[cat] sprintf("%-14s${color3}${fs_bar 5,100 %s}$color ${alignr}${fs_used %s}/${fs_size %s}\n", name, mp, mp, mp)
}
{
	name = val("NAME"); pk = val("PKNAME"); type = val("TYPE"); fs = val("FSTYPE")
	# Children (partitions, LUKS, LVM) inherit transport and removable flag from their disk
	if (pk == "" || !(pk in tran)) { tran[name] = val("TRAN"); rm[name] = val("RM") }
	else { tran[name] = tran[pk]; rm[name] = rm[pk] }

	if (fs == "" || fs == "swap" || fs ~ /^(crypto_LUKS|LVM2_member)$/ || name ~ /^zram/) next
	if (val("SIZE") + 0 < 1073741824) next

	# Prefer "/" when a filesystem is mounted in several places (btrfs subvolumes)
	n = split(val("MOUNTPOINTS"), mps, /\\x0a/); mp = ""
	for (i = 1; i <= n; i++)
		if (mps[i] == "/" || (mps[i] != "" && (mp == "" || length(mps[i]) < length(mp)))) { mp = mps[i]; if (mp == "/") break }
	gsub(/\\x20/, " ", mp)

	label = val("LABEL"); gsub(/\\x20/, " ", label)
	if (label == "") label = name

	if (tran[name] == "usb" || name ~ /^mmcblk/)
		row((rm[name] == "1" || name ~ /^mmcblk/) ? "usb" : "drive", label, mp)
	else if (fs ~ /^(ntfs|ntfs3|BitLocker)$/)
		row("win", label, mp)
	else if (mp != "") {
		base = (mp == "/") ? "Root" : mp
		sub(/.*\//, "", base)
		row("linux", toupper(substr(base, 1, 1)) substr(base, 2), mp)
	}
}
END {
	split("linux win drive usb", order, " ")
	head["linux"] = " Internal Linux"; head["win"] = " Internal Windows"
	head["drive"] = "󰋊 External Drive"; head["usb"] = "󱊞 External USB"
	for (i = 1; i <= 4; i++) {
		c = order[i]
		printf "%s${color3}%s$color\n%s", (i > 1 ? "\n" : ""), head[c], (c in out ? out[c] : "[󱁌 Offline]\n")
	}
}'
