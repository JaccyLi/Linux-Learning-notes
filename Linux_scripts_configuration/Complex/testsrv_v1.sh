#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-29
#FileName:		    testsrv.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		testsrv.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

COLOR_GREEN="\e[1;32m"
COLOR_RED="\e[1;31m"
COLOR_END="\e[0m"
DIR="/var/lock/subsys"
SCR="service"

. /etc/init.d/functions
# success
# failure
# passed
# warning

if [[ ! $1 ]]; then
    echo -e "Usage:`basename $0` {${COLOR_GREEN}start|stop|restart|status${COLOR_END}}"
fi

case $1 in
start)
    if [[ ! -f $DIR/$SCR ]]; then
        mkdir -p $DIR &> /dev/null
        touch $DIR/$SCR &> /dev/null
        echo "Start Succeeded.`success`"
    else
        echo "Already Started.`passed`"
    fi
    ;;
stop)
    if [[ -f $DIR/$SCR ]]; then
        rm $DIR/$SCR &> /dev/null
        echo "Stop completed."
    else
        echo "Already Stopped.`passed`"
    fi
    ;;
restart)
    if [[ -f $DIR/$SCR ]]; then
        rm $DIR/$SCR &> /dev/null
        sleep 0.5
        touch $DIR/$SCR &> /dev/null
        echo "Restart Succeeded.`success`"
    else
        echo "It's Stopped.Now starting...`passed`"
        touch $DIR/$SCR &> /dev/null
        sleep 0.5
        echo "Start Succeeded.`success`"
    fi
    ;;
status)
    if [[ -f $DIR/$SCR ]]; then
        echo -e "$SCR is active.${COLOR_GREEN}[RUNNING]${COLOR_END}"
    else
        echo -e "$SCR is inactive.${COLOR_RED}[STOPPED]${COLOR_END}" 
    fi
    ;;
*) 
    if [[ $1 ]]; then
    echo -e "Usage:`basename $0` {${COLOR_GREEN}start|stop|restart|status${COLOR_END}}"
    else 
    :
    fi
    ;;
esac
