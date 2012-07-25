#!/bin/bash

floating=$(herbstclient floating status)
layout=$(herbstclient layout | sed 's/[^a-z0-9 ]//g' | sed 's/^ //' | cut -d ' ' -f 1)

if [ $floating == "on" ] ; then
	echo "F"
else
	if [ ${layout:0:1} == "g" ] ; then
		echo "G"
	elif [ ${layout:0:1} == "m" ] ; then
		echo "M"
	else
		echo "T"
	fi
fi
