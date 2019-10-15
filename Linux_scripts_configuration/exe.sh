#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-10
#FileName:		    exe.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		exe.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

NUM=$#
declare -i J=0

if [ -f /tmp/mid ]; then
    : > /tmp/mid
fi
echo "$*" | tr -s " " "\n" >> /tmp/mid 

exec 6< /tmp/mid
for ((j=0 ; j<=$NUM ; j++)); do
while read -u 6 I; do
        let J+=1
        if [ -d $I ]; then
            echo "File$J is a directory."
        else
            C=$(echo $(ls -l $I) | cut -c1)
            if [[ "$C" = "-" ]]; then
                echo "File$J is a normal file."
            #elif [[ "$C" = "d" ]]; then
            #    echo "File$J is a directory."
            elif [[ "$C" = "b" ]]; then
                echo "File$J is a block device file."
            elif [[ "$C" = "c" ]]; then
                echo "File$J is a character device file."
            elif [[ "$C" = "l" ]]; then
                echo "File$J is a symbolic link."
            elif [[ "$C" = "p" ]]; then
                echo "File$J is a pipe."
            elif [[ "$C" = "s" ]]; then
                echo "File$J is a socket."
            fi
        fi
done
done
