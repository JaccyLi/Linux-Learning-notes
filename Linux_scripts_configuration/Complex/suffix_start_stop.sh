#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    srffix_start_stop.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		srffix_start_stop.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

for FILE in `ls /etc/rc.d/rc3.d`; do
    SIGN=`echo $FILE | cut -c1`
    if [[ "S" = "$SIGN" ]]; then
        #echo "\"$FILE\" add suffix is \"$FILE stop\"."
        echo "$FILE start"
    elif [[ "K" = "$SIGN" ]]; then
        #echo "\"$FILE\" add suffix is \"$FILE start\"."
        echo "$FILE stop"
    else
        echo "Wrong."
    fi 
done
