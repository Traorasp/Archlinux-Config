#!/usr/bin/env bash

ALARM_FILE="$HOME/.alarm_data"
DEFAULT_DURATION=30

json_output() {
	local text=$1
	local class=$2
	echo "{\"text\":\"$text\",\"class\":\"$class\"}"
}

start_alarm() {
	duration=${1:-$DEFAULT_DURATION}
	end_time=$(date -d "+$duration minutes" +%s)
	echo "$end_time" > "$ALARM_FILE"
	notify-send "Alarm Set" "Alarm will go off in $duration minutes"
	json_output "Alarm Set ($duration min)" "warning"
}

stop_alarm() {
	if [ -f "$ALARM_FILE" ]; then
		rm "$ALARM_FILE"
		notify-send "Alarm Stopped"
		json_output "Alarm Stopped" "inactive"
	else
		notify-send "No Active Alarm"
		json_output "No Alarm" "inactive"
	fi
}

check_alarm() {
	if [ -f "$ALARM_FILE" ]; then
		end_time=$(cat "$ALARM_FILE")
		current_time=$(date +%s)
		if [ "$current_time" -ge "$end_time" ]; then
			notify-send -u critical "ALARM!" "Time's up!"

			# Play sound
			# mpv /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
			rm "$ALARM_FILE"
			json_output "ALARM!" "critical"
		else
			remaining=$((end_time - current_time))
			formatted_time=$(date -u -d @"$remaining" +%H:%M:%S)
			json_output "$formatted_time" "warning"
		fi
	else 
		json_output "No Alarm" "inactive"
	fi
}

case "$1" in
	start)
		start_alarm "$2"
		;;
	stop)
		stop_alarm
		;;
	check)
		check_alarm
		;;
	*)
		json_output "Usage {start [minutes]|stop|check}" "critical"
		exit 1
		;;
esac
