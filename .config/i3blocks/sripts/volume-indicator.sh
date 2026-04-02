#!/bin/bash

# mute indicator
printf "`pactl get-sink-mute @DEFAULT_SINK@ | sed -e 's\Mute: да\🔇\' -e 's\Mute: нет\🔊\'` "




# default sink indikator
DEFAULT_SINK="`pactl get-default-sink`"

case "$DEFAULT_SINK" in
  alsa_output.usb-Sony_INZONE_H9___INZONE_H7-00.HiFi__Headset__sink)
    echo "Наушники"
    ;;
	alsa_output.pci-0000_80_1f.3.analog-stereo)
    echo "Колонки"
    ;;
  *)
		pactl --format json list sinks 2>/dev/null | jq -r --arg default_sink "$DEFAULT_SINK" '.[] | select(.name == $default_sink).description[:10]'
    ;;
esac
