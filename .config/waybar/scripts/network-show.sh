#!/bin/bash

ID=network-show
# flock for exclude run config util twice
flock --nonblock /tmp/$ID.lock alacritty --class $ID --option window.dimensions.columns=120 --option window.dimensions.lines=30 --command nmcli || kill `fuser /tmp/$ID.lock`
