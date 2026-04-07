#!/bin/bash

DATEFMT=${DATEFMT:-"+%a %d.%m.%Y %H:%M:%S"}

OPTIND=1
while getopts ":f:" opt; do
    case $opt in
        f) DATEFMT="$OPTARG" ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

case "$BLOCK_BUTTON" in
  1|2|3) 

  swaymsg -q "exec ~/.config/i3blocks/scripts/calendar-applet.sh"
esac
echo "$LABEL$(date "$DATEFMT")"
