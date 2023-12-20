#!/usr/bin/env bash

# Waybar
# waybar -c $HOME/.config/waybar/config -s $HOME/.config/waybar/style.css &
waybar &

# Wallpaper
swww init
swww img ~/Pictures/wallpapers/programmer.gif

# Dunst 
dunst &

# Cursor
#hyprctl setcursor "Catppuccin-Mocha-Mauve-Cursors" 24
hyprctl setcursor "macOS-BigSur" 24

# Clipboard
wl-clipboard-history -t &

./xdg-portal-hyprland &

# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &


