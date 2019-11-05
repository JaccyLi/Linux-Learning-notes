#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    while_sum.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		while_sum.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

SUM=0
I=1

while [[ $I -le 100 ]]; do
    let SUM+=I
    let I++
done
echo $SUM
