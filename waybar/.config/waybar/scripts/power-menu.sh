#!/usr/bin/env bash

selected=$(printf '󰐥  Apagar\n󰜉  Reiniciar\n󰍃  Cerrar sesión\n󰌾  Bloquear\n  Cerrar\n' |
    wofi \
        --dmenu \
        --columns=2 \
        --width=300 \
        --height=154 \
        --location=3 \
        --hide-scroll \
        --hide-search \
        --xoffset -22 \
        --yoffset 4 \
        --cache-file=/dev/null \
        --style="$HOME/.config/wofi/power-menu.css"
)

case "$selected" in
    *"Apagar"*)
        systemctl poweroff
        ;;
    *"Reiniciar"*)
        systemctl reboot
        ;;
    *"Cerrar sesión"*)
        hyprctl dispatch exit
        ;;
    *"Bloquear"*)
        hyprlock
        ;;
esac
