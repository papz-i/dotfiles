#!/bin/bash
# References: 
# https://www.baeldung.com/linux/get-cpu-usage

storage=$(df -h | grep /dev/sda7 | cut -d" " -f17)
memory=$(free -k | grep "Mem:" | awk '{printf "%.2f", $7/$2*100}' ; echo "%")
cpu=$(echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%")

echo " $cpu   $memory   $storage" 

