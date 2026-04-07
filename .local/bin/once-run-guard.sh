#!/bin/bash

# finish a current script if script with same id already running
# example:
# source once-run-guard.sh unique-script-id

get_lock() {
	local LOCK_FD=9
	# need to use eval here for proper expansion
	eval "exec $LOCK_FD>/tmp/$1.lock"
	flock -n $LOCK_FD
}

get_lock || exit
