#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-10
#FileName:		    createUser.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		createUser.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

USER_EXIST=2

if [ $# -eq 0 ]; then
    echo "Usage:`basename $0` user"
else

    if id $1 &> /dev/null; then
        echo "User $1 exists.Exiting..."
        exit $USER_EXIST
    else
        useradd $1 
        [ $? -eq 0 ] && echo -e "User $1 added.\nThe info of $1 as folloes:\n"
        id $1
    fi

fi
unset USER_EXIST
