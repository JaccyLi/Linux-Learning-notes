#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    2_9X9.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		2_9X9.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#1x1=1
#2x1=2   2x2=4
#3x1=3   3x2=6   3x3=9


for i in {1..9}; do 
    for j in $(seq $i); do
    let RESULT=$(($i*$j))
       # for k in "3 4"; do
       #     if [[ $i -eq $k ]] && [[ $j -eq 2 ]]; then
       #         echo -en "|${i}x$j=$RESULT   "
       #     fi
       # done
    echo -en "|${i}x$j=$RESULT\t"
    done
    echo
done
