#!/bin/bash

source $HOME/.config/herbstluftwm/panel_settings.sh

visible=1
space_width=$(textwidth "$FONT" " ")

herbstclient pad $monitor $PANEL_PADDING

TAGS=( $(herbstclient tag_status $monitor) )
MODE=$($HOME/.config/herbstluftwm/tag_mode.sh)

windowtitle=""

# left side
herbstclient --idle | while true ; do
	# launcher:
	#echo -n "^ca(1,$HOME/bin/mygtkmenu.py)^fg($HI_FG)$ICON^fg()^ca()"
	echo -n "$spacer"

	# tags list:
	for i in "${TAGS[@]}" ; do
		box_width=$(textwidth "$FONT" " ${i:1} ")
		case ${i:0:1} in
			'#') # currently focused tag
				#echo -n "^bg($selbg)^fg($selfg)"
				echo -n "^bg($selbg)^fg($selborder)^ro(${box_width}x11)^ib(1)^p(-$box_width)^fg($selfg)"
				;;
			'+') # focused tag on unfocused monitor
				echo -n "^bg()^fg()"
				;;
			':') # occupied, unfocused tag
				echo -n "^bg($occbg)^fg($occfg)"
				;;
			'!') # tag contains urgent window
				echo -n "^bg($urgbg)^fg($urgfg)"
				;;
			*) # unfocused, unoccupied tag
				echo -n "^bg($emptybg)^fg($emptyfg)"
				;;
		esac

		echo -n "^ca(1,herbstclient focus_monitor $monitor && "'herbstclient use "'${i:1}'") '${i:1}" ^ca() "
	done

	#echo -n "^bg()^fg()  $sep $spacer"
	echo -n "^bg()^fg()   [${MODE:0:1}] $spacer"

	echo "${windowtitle//^/^^}"

	read line || break
	cmd=( $line )
	case "${cmd[0]}" in
		tag*)
			#echo "reseting tags" >&2
			TAGS=( $(herbstclient tag_status $monitor) )
			MODE=$($HOME/.config/herbstluftwm/tag_mode.sh)
			;;
		layoutchanged)
			MODE=$($HOME/.config/herbstluftwm/tag_mode.sh)
			;;
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
		focus_changed|window_title_changed)
			windowtitle="${cmd[@]:2}"
			;;
	esac
done | dzen2 -ta 'l' -x $X_LEFT -y $Y_POS -w $PANEL_WIDTH -h $PANEL_HEIGHT -fn $FONT -bg $PANEL_BG -fg $PANEL_FG -p
