#!/bin/bash

#
# ref:
#   - https://www.reddit.com/r/GPDPocket/comments/8gxo72/linux_script_to_read_battery_draincharge_rate_in/
#   - https://gist.github.com/parkerlreed/08a6c40dce5d83f2dc329faea80a9256
#

voltage() { cat /sys/class/power_supply/fusb302-typec-source/voltage_now; }
voltage_actual() { cat /sys/class/power_supply/max170xx_battery/voltage_now; } 
current_actual() { cat /sys/class/power_supply/max170xx_battery/current_now; } 
current() { cat /sys/class/power_supply/fusb302-typec-source/current_max; } 
current_limit() { cat /sys/class/power_supply/bq24190-charger/input_current_limit; }
capacity() { cat /sys/class/power_supply/max170xx_battery/capacity; }
breaker() { echo "------------------------------------------------------"; }

echo "Voltage: $(expr `voltage` / 1000000)V DC"  
echo "Voltage (battery): $(echo 'scale=2; '$(voltage_actual)'/1000000' | bc)V DC"
echo "Current (battery): $(echo 'scale=2; '$(current_actual)'/1000000' | bc)A"
echo "Current (negotiated): $(echo 'scale=2; '$(current)'/1000000' | bc)A"
echo "Current (max): $(echo 'scale=2; '$(current_limit)'/1000000' | bc)A"
echo "Capacity: $(capacity)%"	


