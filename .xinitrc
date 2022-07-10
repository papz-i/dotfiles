#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xsetroot -cursor_name left_ptr

picom --experimental-backend -b &

nitrogen --restore &

export _JAVA_AWT_WM_NONREPARENTING=1 &

killall xmobar &

exec xmonad


