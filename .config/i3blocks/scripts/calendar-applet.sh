#!/bin/bash

get_lock() {
	local LOCK_FD=9
	# need to use eval here for proper expansion
	eval "exec $LOCK_FD>/tmp/callendar-applet.lock"
	flock -n $LOCK_FD
}

get_lock || exit

alacritty --class callendar-applet \
	--option window.dimensions.columns=75 --option window.dimensions.lines=19 \
	--option window.opacity=0.9 \
	--command ikhal --config ~/.config/khal/config-applet \
	> /dev/null

