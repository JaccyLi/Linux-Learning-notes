#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-29
#FileName:		    random_max_min.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		random_max_min.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

i=0
MAX=$RANDOM
MIN=$RANDOM
while [[ $i -lt 10 ]]; do
    if (( MAX >= MIN )); then
        :
    else
        MID=$MAX
        MAX=$MIN
        MIN=$MID
    fi
    let i++
done
echo MAX=$MAX
echo MIN=$MIN

