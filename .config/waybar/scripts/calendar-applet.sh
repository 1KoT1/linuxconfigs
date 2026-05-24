#!/bin/bash

ID=callendar-applet

flock --nonblock /tmp/$ID.lock \
	alacritty --class $ID \
		--option window.dimensions.columns=75 --option window.dimensions.lines=19 \
		--option window.opacity=0.9 \
		--command ikhal --config ~/.config/khal/config-applet \
	|| kill `fuser /tmp/$ID.lock`

