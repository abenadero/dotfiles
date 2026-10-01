#!/usr/bin/env bash
set -u

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FRAME_TIME="${FRAME_TIME:-0.0166667}"
ROWS=19

restore_terminal() {
    printf '\e[0m\e[?25h'
}

stop() {
    restore_terminal
    exit 0
}

trap stop INT TERM
trap restore_terminal EXIT

printf '\e[?25l'

while true; do
    for frame in "$DIR"/frames/*.ansi; do
        # Clear only Cosmo's drawing area so characters from the previous
        # frame cannot remain when an object moves into a shorter line.
        printf '\e[H'
        for ((row=1; row<=ROWS; row++)); do
            printf '\e[2K'
            if (( row < ROWS )); then
                printf '\e[1B\r'
            fi
        done

        printf '\e[H'
        cat "$frame"
        sleep "$FRAME_TIME"
    done
done
