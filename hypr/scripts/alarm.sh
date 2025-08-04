#!/usr/bin/env bash

ALARM_FILE="$HOME/.alarm_data"
DEFAULT_DURATION=30

json_output() {
	local text=$1
	echo "{\"text\":\"$text\"}"
}

start_alarm() {
	duration=${1:-$DEFAULT_DURATION}
	end_time=$(date -d "+$duration minutes" +%s)
	echo "$end_time" > $ALARM_FILE
	notify-send "Alarm Set" "Alarm will go off in $duration minutes"
	json_output "Alarm Set $duration min"
}

stop_alarm() {
	if [ -f "$ALARM_FILE" ]; then
		rm "$ALARM_FILE"
		notify-send "Alarm stopped"
		json_output "None"
	else 
		notify-send "No active alarm ii"
		json_output "None"
	fi
}

check_alarm() {
	if [ -f "$ALARM_FILE" ]; then
		end_time=$(cat "$ALARM_FILE")
		end_time=${end_time:-0}
		current_time=$(date +%s)
		if [ $current_time -ge $end_time ]; then
			notify-send "TIMES UP!"
			json_output "ALARM!"

			rm "$ALARM_FILE"
			paplay $HOME/.config/hypr/sounds/piano_alarm.wav &
		else
			remaining=$((end_time - current_time))
			formatted_time=$(date -u -d @"$remaining" +%M:%S)
			json_output "$formatted_time"
		fi
	else 
		json_output ""
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
		check_alarm
		;;
esac
