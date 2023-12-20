#!/usr/bin/env bash

images_path=$HOME/Pictures/wallpapers/
variations=("programmer.gif" "terracevibe.gif" "lounge.gif" "japancity.gif" "riverside.gif")
number=$(($RANDOM % 5))
image=${variations[$number]}
wallpaper=$images_path$image

swww img $wallpaper --transition-type grow --transition-pos 0.9,0.1 --transition-duration 1.5 --transition-fps 90
