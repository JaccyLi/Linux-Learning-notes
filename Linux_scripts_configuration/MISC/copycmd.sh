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

DEST_DIR="/mnt/sysroot"


while :; do
read -p "Please input the command you wanna move:" CMD 
    if [[ "$CMD" = "q" ]]; then
        exit
    fi
    CMD_FULL_PATH=`which --skip-alias $CMD`
    CMD_DESTDIR=`dirname $CMD_FULL_PATH`
    CMD_MOVED=`basename $CMD_FULL_PATH`

##########
#echo $CMD_FULL_PATH
#echo $CMD_DESTDIR
#echo $CMD_MOVED
##########

    mkdir -pv ${DEST_DIR}${CMD_DESTDIR}
    cp -a $CMD_FULL_PATH ${DEST_DIR}$CMD_DESTDIR

#ldd "/usr/bin/cp" | sed -nr 's#.*(/.*) .*#\1#p'
    SO_LIST=`ldd "$CMD_FULL_PATH" | sed -nr 's#.* (/.*) .*#\1#p'`
    for SO_FILE in $SO_LIST; do
    echo $SO_FILE
        SO_FULL_PATH=`echo $SO_FILE`
        SO_DESTDIR=`dirname $SO_FILE`
        SO_MOVED=`basename $SO_FILE`
##########
#echo SO_FULL_PATH=$SO_FULL_PATH
#echo SO_DESTDIR=$SO_DESTDIR
#echo $SO_MOVED
##########
        if [[ ! -d ${DEST_DIR}${SO_DESTDIR} ]]; then
            mkdir -p ${DEST_DIR}${SO_DESTDIR}
        else
            cp -a $SO_FILE ${DEST_DIR}${SO_DESTDIR}
            echo "$SO_FILE moved to ${DEST_DIR}${SO_DESTDIR}." 
        fi
    done
done
