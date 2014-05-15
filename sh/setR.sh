#!/bin/bash
xrandr --newmode "1280x960_60.00"  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync
xrandr --addmode VGA1 1280x960_60.00
xrandr -s 1280x960_60.00
#fcitx-qimpanel &
