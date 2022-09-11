NOW=$(date +'%s')
BAT=$(system_profiler SPPowerDataType | grep -A1 -B7 "Condition")
OUT="Time: $NOW
$BAT" 
echo "$OUT" >> ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Logs/Battery\ Log.txt

BAT2=$(system_profiler SPPowerDataType | grep -B3 "State of Charge" | awk -F ":" '{
ORS=", ";
  sub(/^[ \t]+/, "\""); 
  sub(/The battery’s charge is below the critical level/, "Subcritical Level");
  sub(/No$/, "false");
  sub(/Yes$/, "true");
  print $1 "\":" $2
  }')
BAT3=$(system_profiler SPPowerDataType | grep -A2 "Cycle Count" | awk -F ":" '{
  ORS=", ";
  sub(/^[ \t]+/, "\""); 
  sub(/The battery’s charge is below the critical level/, "Subcritical Level");
  sub(/Service Recommended$/, "Service Recommended");
  sub(/Normal$/, "\"Normal\"");
  sub(/%$/, "");
  print $1 "\":" $2;
  }')
OUT2="\"Time\": $NOW, $BAT2 $BAT3" 
echo "$OUT2" | sed 's/..$//' >> ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Logs/Temp\ Battery\ Log.txt

TEMP0=$( tail -n 1 ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Logs/Temp\ Battery\ Log.txt)
TEMP="${TEMP0/Subcritical Level/SubcriticalLevel}"
TEMP="${TEMP/Fully Charged/FullyCharged}"
TEMP="${TEMP/Cycle Count/CycleCount}"
TEMP="${TEMP/Maximum Capacity/MaximumCapacity}"
TEMP=$(echo $TEMP | sed -re 's/State of Charge [(]%[)]/StateOfChargePct/g')
TEMP1=$(echo $TEMP | awk '{ print ", {"} {print}  {print "}" } END {print "]}"}')
sed -i "" "$(( $(wc -l <~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Logs/cat1.txt)-1+1 )),$ d" ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Logs/Battery.json
echo "$TEMP1" >> ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Logs/Battery.json