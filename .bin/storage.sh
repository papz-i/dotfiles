echo "Storage:" $(df -h | grep /dev/sda7 | cut -d" " -f17)

exit 0
