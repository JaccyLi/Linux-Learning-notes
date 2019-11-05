#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-11-02
#FileName:		    guess_num_game.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		guess_num_game.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
. /etc/init.d/functions
# success
# passed
# wrning
# failure

COLOR_GREEN="\e[1;32m"
COLOR_END="\e[0m"
SEED=$[$RANDOM%100+1]

COUNT=0
while :; do
read -p "Please input a num(1-100): "  N
if [[ $COUNT -eq 5 ]]; then
    echo "You've input 5 times, Exiting...`failure`" 
    exit
else
    if [[ $N =~ ^[0-9]+$ ]]; then                                                      
       if [[ $N -gt $SEED ]]; then
            echo "Too big." 
        elif [[ $N -lt $SEED ]]; then
            echo "Too small." 
            
        elif [[ $N -eq $SEED ]]; then
            echo "Nice.`success`"
            exit
        fi
        let COUNT++
    fi
fi
done
