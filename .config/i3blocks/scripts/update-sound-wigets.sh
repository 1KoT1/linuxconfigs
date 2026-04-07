#!/bin/bash
#
# On any changes from pactl subscribe send signal 1 to i3blocks for update sound wogets
pactl subscribe | while read line; do pkill -RTMIN+1 i3blocks; done

