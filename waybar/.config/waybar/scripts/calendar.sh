#!/usr/bin/env bash

# ---------- colors ----------

colors_file="$HOME/.config/colors/catppuccin-mocha.css"

get_color() {
    awk -v name="$1" '
        $1 == "@define-color" && $2 == name {
            gsub(";", "", $3)
            print $3
        }
    ' "$colors_file"
}

text=$(get_color text)
mauve=$(get_color mauve)
green=$(get_color green)
rosewater=$(get_color rosewater)

# ---------- date ----------

year=$(date +%Y)
month_num=$(date +%m)
today=$(date +%-d)

month=$(date +%B)
month="${month^}"

days_in_month=$(date -d "$year-$month_num-01 +1 month -1 day" +%-d)
first_weekday=$(date -d "$year-$month_num-01" +%u)

# ---------- pango ----------

month_pango="<span size='18pt' weight='600' letter_spacing='750' color='$mauve'>$month $year</span>"

weekdays_pango="<span weight='600' color='$green'> L   M   X   J   V   S   D </span>"

days_pango=""
row=""

# Empty cells before day 1
for ((i=1; i<first_weekday; i++)); do
    row+="    "
done

# Days
for ((day=1; day<=days_in_month; day++)); do
    cell=$(printf "%2d  " "$day")

    if (( day == today )); then
        cell="<span weight='bold' color='$rosewater'>$cell</span>"
    else
        cell="<span color='$text'>$cell</span>"
    fi

    row+="$cell"

    weekday=$(( (first_weekday + day - 2) % 7 + 1 ))

    if (( weekday == 7 )); then
        days_pango+="$row\n"
        row=""
    fi
done

# Last incomplete week
if [[ -n "$row" ]]; then
    days_pango+="$row"
fi

# ---------- output ----------

tooltip="$month_pango\n\n$weekdays_pango\n$days_pango"

time=$(date '+%H:%M')

printf '{"text":"%s","tooltip":"%s"}\n' \
    "$time" \
    "$tooltip"
