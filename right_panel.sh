#!/bin/bash

source $HOME/.config/herbstluftwm/panel_settings.sh

visible=1

function uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}
# right side:
herbstclient --idle | {
	cstatus &
	while true ; do
		read line || break
		cmd=( $line )
		case "${cmd[0]}" in
			quit_panel)
				exit
				;;
			togglehidepanel)
				echo -n "^togglehide()"
				if [ $visible -eq 1 ] ; then
					visible=0
					herbstclient pad $monitor 0
				else
					visible=1
					herbstclient pad $monitor $PANEL_PADDING
				fi
				;;
			reload)
				exit
				;;
		esac
	done
} | dzen2 -ta 'r' -x $X_RIGHT -y $Y_POS -w $PANEL_WIDTH -h $PANEL_HEIGHT -fn $FONT -bg $PANEL_BG -fg $PANEL_FG -p
