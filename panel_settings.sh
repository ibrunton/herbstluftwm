#!/bin/bash

set -f

HERBST_DIR=$HOME/.config/herbstluftwm

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ; then
	echo "Invalid monitor $monitor"
	exit 1
fi

X_LEFT=${geometry[0]}
Y_POS=${geometry[1]}
PANEL_WIDTH=$((${geometry[2]} /2))
X_RIGHT=$PANEL_WIDTH
PANEL_HEIGHT=12
PANEL_PADDING=10

# colours
PANEL_BG="#222222"
PANEL_FG="#8f8f8f"
DATA_FG="#e0e0e0"
HI_FG="#4abcd4"
CRIT_FG="#cd5666"

selborder="#426797" #selbg="#0abcd0"
selbg=$PANEL_BG
selfg=$HI_FG
occbg=$PANEL_BG
occfg=$HI_FG
emptybg=$PANEL_BG
emptyfg=$PANEL_FG

# XBM icons
ICONS=$HOME/.config/icons/xbm8x8

# menu icon
ICON=" -A- "

spacer="^fg()   " # standard spacer
sep="^fg()|" # separator

# font
FONT="-*-ohsnap.icons-medium-r-normal-*-11-79-100-100-C-60-ISO8859-1"

# conky config file
CONKY_FILE=$HERBST_DIR/conkyrc2

# Try to find textwidth binary.
if [ -e "$(which textwidth 2> /dev/null)" ] ; then
    textwidth="textwidth";
elif [ -e "$(which dzen2-textwidth 2> /dev/null)" ] ; then
    textwidth="dzen2-textwidth";
else
    echo "This script requires the textwidth tool of the dzen2 project."
    exit 1
fi


