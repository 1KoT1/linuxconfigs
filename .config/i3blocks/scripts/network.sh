#!/bin/bash

# open config
case "$BLOCK_BUTTON" in
  1|2|3) 

  ID=network-manager-config
  # flock for exclude run config util twice
  swaymsg -q "exec flock --nonblock /tmp/$ID.lock alacritty --class $ID --option window.dimensions.columns=120 --option window.dimensions.lines=30 --command nmtui"
esac

# iface indicator
/usr/share/i3blocks/iface



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

