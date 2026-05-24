#!/bin/bash

ID=network-manager-config
# flock for exclude run config util twice
flock --nonblock /tmp/$ID.lock alacritty --class $ID --option window.dimensions.columns=120 --option window.dimensions.lines=30 --command nmtui
