#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    create_random_file_name.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		create_random_file_name.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#1AbCdeFgH.html 

for ((i=1 ; i <= 10 ; i++)); do
    mkdir -p ~/testdir/$i$(cat /dev/random | tr -cd [:alpha:]  | head -c8).html
done


