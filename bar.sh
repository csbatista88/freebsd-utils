#!/bin/sh

fn_clock(){
	data=$(date '+%a %d-%b-%Y %H:%M')
	echo "[📅 $data]"
}

fn_os(){
	OS=$(uname -s)
	echo "[👿 $OS"
}
fn_ram(){
#	RAM=$(top | grep Mem | cut -d " " -f 12)
	RAM=$(echo "$(sysctl -n vm.stats.vm.v_free_count) *  $(sysctl -n hw.pagesize) / ( 1024 * 1024 )" | bc)
	echo "Free:$RAM]"
}

fn_battery(){
	battery=$(sysctl hw.acpi.battery.life | cut -c23-25)
	echo "[🔋 $battery%]"
}
fn_sound(){
	sound=$(cat /dev/sndstat | grep default | cut -c1-4)
	echo "[$sound"
}
fn_vol(){
#	mixer -f /dev/mixer2 vol.volume 
	vol=$(echo "$(mixer -o | grep vol.volume | cut -c 12-15) * 100 / 1" | bc)
	echo "🔊 $vol%]"
}

fn_vpn(){
	status_vpn=$(ifconfig | grep tun0)
	if ifconfig | grep tun0 &>/dev/null; then
		echo "[vpn:OFF]"
	else 
		echo "[vpn:ON]"
	fi
}

fn_main(){
while true; do
	xsetroot -name "$(fn_vpn) $(fn_battery) $(fn_sound)$(fn_vol) $(fn_clock) $(fn_os) $(fn_ram)";
	sleep 60;
done
}

fn_main
