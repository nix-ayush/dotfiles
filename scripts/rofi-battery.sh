#!/bin/sh

# Get current battery data from sysfs
LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
STATUS=$(cat /sys/class/power_supply/BAT1/status)

# Display the info in Rofi
echo "Status: $STATUS
Charge: $LEVEL%" | rofi -dmenu -p "Battery Info" -theme-str 'window { width: 20%; }'
