#!/usr/bin/env bash

set -u

COSMO_DIR="$HOME/.config/fastfetch/Cosmo/Cosmo_ANSI"
FRAMES_DIR="$COSMO_DIR/frames"

COSMO_WIDTH=42
COSMO_HEIGHT=19
GAP=4
FASTFETCH_COL=$((COSMO_WIDTH + GAP + 1))

cleanup() {
    printf '\033[0m'
    printf '\033[?25h'
    printf '\033[%d;1H\n' "$((COSMO_HEIGHT + 2))"
    exit 0
}

trap cleanup INT TERM

clear
printf '\033[?25l'

# Fastfetch: conservar colores aunque su salida esté redirigida.
mapfile -t FF_LINES < <(fastfetch --logo none --pipe false)

# Pintarlo una sola vez a la derecha.
for i in "${!FF_LINES[@]}"; do
    printf '\033[%d;%dH%s' \
        "$((i + 1))" \
        "$FASTFETCH_COL" \
        "${FF_LINES[$i]}"
done

# Animación.
while true; do
    for frame in "$FRAMES_DIR"/*.ansi; do

        # Limpiamos SOLO la zona de Cosmo.
        for ((row=1; row<=COSMO_HEIGHT; row++)); do
            printf '\033[%d;1H' "$row"
            printf '%*s' "$COSMO_WIDTH" ''
        done

        # Volvemos al origen de Cosmo y pintamos el frame.
        printf '\033[1;1H'
        cat "$frame"

        sleep 0.0167
    done
done
