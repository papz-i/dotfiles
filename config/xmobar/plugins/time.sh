#!/bin/bash

hour=$(date | cut -d" " -f5 | cut -d":" -f1)

case $hour in
  01) clock='' ;;
  02) clock='' ;;
  03) clock='' ;;
  04) clock='' ;; 
  05) clock='' ;;
  06) clock='' ;;
  07) clock='' ;;
  08) clock='' ;;
  09) clock='' ;;
  10) clock='' ;;
  11) clock='' ;;
  12) clock='' ;;
  *)  clock='' ;;
esac

echo $clock

exit 0

    
