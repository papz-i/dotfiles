
#!/bin/sh

percentage=$(amixer -c 1 sget Master | grep "Mono: " | awk '{print $4}' | tr -d [])

if [ $percentage = '0%' ]; then 
	echo 婢
else
	echo  $percentage
fi

exit 0
