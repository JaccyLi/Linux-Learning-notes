#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    add_10_user.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		add_10_user.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
. /etc/init.d/functions
# success
# failure
# passed
# warning

for ((i=1 ; i<=10 ; i++)); do
    if id user${i} &> /dev/null; then
        echo user$i exists.
        continue
    else
        useradd user$i 
        PASS=` echo $RANDOM | md5sum | cut -c1-8`
        echo $PASS | passwd --stdin user$i &> /dev/null
        echo "user$i created.`success`"
    fi
done
