#!/usr/bin/env bash

ALARM_SCRIPT="$HOME/.config/hypr/scripts/alarm.sh"

json_output() {
    echo "{\"text\":\"$1\",\"class\":\"$2\"}"
}

case "$1" in
    alarm-menu)
        # Get current alarm status (parsed from JSON)
        status=$($ALARM_SCRIPT check | jq -r '.text')
        
        if [[ "$status" == "No alarm" ]]; then
            # No alarm set - show creation menu
            ACTION=$(printf "30min Alarm\n1hr Alarm\nCustom Alarm" | rofi -dmenu -p "Set Alarm")
            case "$ACTION" in
                "30min Alarm") $ALARM_SCRIPT start 30 ;;
                "1hr Alarm") $ALARM_SCRIPT start 60 ;;
                "Custom Alarm") 
                    DURATION=$(rofi -dmenu -p "Enter minutes (1-240)")
                    if [[ "$DURATION" =~ ^[0-9]+$ ]] && (( DURATION > 0 && DURATION <= 240 )); then
                        $ALARM_SCRIPT start "$DURATION"
                    else
                        notify-send "Invalid Duration" "Please enter 1-240 minutes"
                    fi
                    ;;
            esac
        else
            # Alarm exists - show management menu
            ACTION=$(printf "Stop Alarm\nChange Alarm" | rofi -dmenu -p "Alarm Active ($status)")
            case "$ACTION" in
                "Stop Alarm") $ALARM_SCRIPT stop ;;
                "Change Alarm")
                    DURATION=$(rofi -dmenu -p "New duration (minutes)")
                    if [[ "$DURATION" =~ ^[0-9]+$ ]]; then
                        $ALARM_SCRIPT stop
                        $ALARM_SCRIPT start "$DURATION"
                    fi
                    ;;
            esac
        fi
        ;;
    *)
        # Get raw JSON from alarm script
        json_data=$($ALARM_SCRIPT check 2>/dev/null)
        
        # Validate JSON before output
        if jq -e . >/dev/null 2>&1 <<<"$json_data"; then
            echo "$json_data"
        else
            json_output "Error" "critical"
        fi
        ;;
esac
