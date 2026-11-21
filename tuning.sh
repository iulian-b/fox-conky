#!/bin/sh
##########################################
##			     ƒøxglove			    ## 
##			   ƒøx-conky-v2			    ## 
##			  tuning script		        ## 
##########################################

# Prints the TUNING section for conky's ${texecpi}, read live each run.
# Lines whose source doesn't exist on this machine are left out, such as 3D V-Cache on non-X3D CPUs, GPU profile without LACT, etc.
# This section is tailor-made for my system. so if you end up with no real usable info out of this one, just axe the section entirely. 

cpu=/sys/devices/system/cpu

# Icon, label, value
line() {
	[ -n "$3" ] && printf '%s %s: ${alignr}${color3}(%s)${color}\n' "$1" "$2" "$(printf '%s' "$3" | sed 's/\$/$$/g')"
}

if [ -r $cpu/amd_pstate/status ]; then
	line '' 'P-State Driver' "$(cat $cpu/amd_pstate/status)"
else
	line '' 'CPU Driver' "$(cat $cpu/cpu0/cpufreq/scaling_driver 2>/dev/null)"
fi

if [ -r $cpu/cpu0/cpufreq/energy_performance_preference ]; then
	line '' 'P-State EPP' "$(cat $cpu/cpu0/cpufreq/energy_performance_preference)"
else
	line '' 'CPU Governor' "$(cat $cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)"
fi

boost=$(cat $cpu/cpufreq/boost 2>/dev/null || cat $cpu/cpufreq/policy0/boost 2>/dev/null)
case $boost in 1) boost=on ;; 0) boost=off ;; esac
line '' 'P-State Core Boost' "$boost"

for f in /sys/bus/platform/drivers/amd_x3d_vcache/*/amd_x3d_mode; do
	[ -r "$f" ] && line '' '3D V-Cache Optimizer' "$(cat "$f")"
done

# Scheduler of the disk holding / (walks down through LUKS/LVM to the disk)
root=$(findmnt -n -o SOURCE / | sed 's/\[.*//')
disk=$(lsblk -srno NAME,TYPE "$root" 2>/dev/null | awk '$2 == "disk" { print $1; exit }')
sched=$(sed -n 's/.*\[\(.*\)\].*/\1/p' "/sys/block/$disk/queue/scheduler" 2>/dev/null)
line '󰋊' 'I/O Scheduler' "$sched"

command -v lact >/dev/null && line '' 'GPU Profile' "$(lact cli profile 2>/dev/null)"
