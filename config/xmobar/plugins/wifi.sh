#!/bin/sh

# From:
# https://github.com/pimeys/dotfiles/blob/home_macbook/dot.bin/wireless.sh

detectwired=`nmcli con show | grep "enp1s0" | awk '{print $6}'`
detectwireless=`nmcli con show | grep "wlp2s0" | awk '{print $4}'`

essid=`iwconfig wlp2s0 | grep ESSID | cut -d':' -f2 | tr -d '"'`
stngth=`sudo iwconfig wlp2s0 | grep 'Link Quality' |cut -d'=' -f2|cut -d'/' -f1`
# bars=`expr $stngth / 7`

# case $bars in
#   0)  bar='' ;;
#   1)  bar='' ;;
#   2)  bar='' ;;
#   3)  bar='' ;;
#   4)  bar='' ;;
#   5)  bar='' ;;
#   6)  bar='' ;;
#   7)  bar='' ;;
#   8)  bar='' ;;
#   9)  bar='' ;;
#   10) bar='' ;;
#   *)  bar='' ;;
# esac


if [[ $detectwired == "enp1s0" && $detectwireless == "wlp2s0" ]]; then
  echo "  &  " $essid 
elif [[ $detectwireless == "wlp2s0" ]]; then 
  echo "  "$essid
elif [ $detectwired == "enp1s0" ]; then
  echo " Wired"
else
  echo "  No Connection"
fi 

exit 0
