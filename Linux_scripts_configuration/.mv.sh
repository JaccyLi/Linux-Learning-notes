#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-12
#FileName:		    .mv.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		.mv.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
FILE=$@
if [ $# -gt 0 ]; then
        if [ ! -d /data/tmp ]; then
            mkdir -p /data/tmp
            echo "你删除的文件会被放到:/data/tmp"
        fi
        mktemp -d /data/tmp/`date +%T`-XXXXX 1> /data/tmp/dirname 2> /dev/null
        dir=`cat /data/tmp/dirname`
    mv -t $dir $FILE
        echo "Moved $FILE to /data/tmp ..."
else
        echo "No file moved to /data/tmp/ "

fi
