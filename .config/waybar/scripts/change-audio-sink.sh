#!/bin/bash

HEADPHONES="alsa_output.usb-Sony_INZONE_H9___INZONE_H7-00.HiFi__Headset__sink"
AUDIO_SPEAKERS="alsa_output.pci-0000_80_1f.3.analog-stereo"

CURRENT_SINK=`pactl get-default-sink`
case "$CURRENT_SINK" in
	"$HEADPHONES")
		pactl set-default-sink $AUDIO_SPEAKERS
		;;
	"$AUDIO_SPEAKERS")
		pactl set-default-sink $HEADPHONES
		;;
esac
