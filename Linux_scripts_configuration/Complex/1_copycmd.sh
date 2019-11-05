#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-29
#FileName:		    copycmd.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		copycmd.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
#. /etc/init.d/functions
# success
# passed
# wrning
# failure

COLOR_GREEN="\e[1;32m"
COLOR_END="\e[0m"
DEST_DIR="/mnt/root"


while :; do
read -p "Please input the command you wanna move(q:quit):" CMD 
    if [[ "$CMD" = "q" ]]; then
        exit
    fi

    CMD_FULL_PATH=`which --skip-alias $CMD`
#    echo CMD_FULL_PATH=$CMD_FULL_PATH
    CMD_DESTDIR=`dirname $CMD_FULL_PATH`
#    echo CMD_DESTDIR=$CMD_DESTDIR
    CMD_MOVED=`basename $CMD_FULL_PATH`
#    echo CMD_MOVED=$CMD_MOVED

    if [[ ! -d ${DEST_DIR}${CMD_DESTDIR} ]]; then
        mkdir -p ${DEST_DIR}${CMD_DESTDIR} &> /dev/null
    else
        cp -a $CMD_FULL_PATH ${DEST_DIR}$CMD_DESTDIR
    fi

    SO_LIST=`ldd "$CMD_FULL_PATH" | sed -nr 's#.* (/.*) .*#\1#p'`
    for SO_FILE in $SO_LIST; do
        SO_FULL_PATH=`echo $SO_FILE`
        SO_DESTDIR=`dirname $SO_FILE`
        SO_REAL=$(basename `ls -l $SO_FILE | sed -nr 's#.* (.*)#\1#p'`)
        if [[ ! -d ${DEST_DIR}${SO_DESTDIR} ]]; then
            mkdir -p ${DEST_DIR}${SO_DESTDIR} &> /dev/null
        else
            cp -a ${SO_DESTDIR}/${SO_REAL} ${DEST_DIR}${SO_DESTDIR}
#            echo "$SO_FILE -> ${SO_DESTDIR}${SO_REAL} moved to ${DEST_DIR}${SO_DESTDIR}." 
        fi
    done
    echo -e "Command ${COLOR_GREEN}$CMD${COLOR_END} and corresponding libs moved to dir /mnt/sysroot/"
done

unset COLOR_GREEN
unset COLOR_END
unset DEST_DIR
unset CMD_FULL_PATH
unset CMD_DESTDIR
unset CMD_MOVED
unset SO_LIST
unset SO_FULL_PATH
unset SO_DESTDIR
unset SO_REAL
