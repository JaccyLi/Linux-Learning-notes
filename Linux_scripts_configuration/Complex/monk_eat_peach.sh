#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    monk_eat_peach.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		monk_eat_peach.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#


LAST=1

for (( I=1 ; I<=9 ; I++ )); do


let LAST=$(( LAST + 1 ))*2


done

echo $LAST
