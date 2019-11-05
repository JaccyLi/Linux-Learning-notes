#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-27
#FileName:		    indicate_file_type.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		indicate_file_type.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
GREEN="\e[32m"
CYAN="\e[36m"
END="\e[0m"

indicate ()
{

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
            echo -e "File $i is a ${GREEN}dir${END}." > /tmp/dir.log
        else
            C=$(echo $(ls -l $I) | cut -c1)
            if [[ "$C" = "-" ]]; then
                echo -e  "File $i is a normal file." > /tmp/normal.log
            #elif [[ "$C" = "d" ]]; then
            #    echo "File$J is a directory."
            elif [[ "$C" = "b" ]]; then
                echo -e  "File $i is a block device file." > /tmp/block.log
            elif [[ "$C" = "c" ]]; then
                echo -e  "File $i is a character device file." > /tmp/char.log
            elif [[ "$C" = "l" ]]; then
                echo -e  "File $i is a ${CYAN}symble link${END}." > /tmp/symble.log
            elif [[ "$C" = "p" ]]; then
                echo -e  "File $i is a pipe."
            elif [[ "$C" = "s" ]]; then
                echo -e  "File $i is a socket."
            fi
        fi
done
done
}

main() 
{
    echo "Indicating..."
for i in `find /var/` ; do 
    indicate $i 
    #if [[ -f $j ]]; then
    #    echo -e "$j is a normalfile" #>> /tmp/normalfile.out
    #elif [[ -d $j ]]; then
    #    echo -e  "$j is a ${GREEN}dir${END}" #>> /tmp/dir.out 
    #elif [[ -h $j ]]; then
    #    echo -e  "$j is a ${CYAN}symblelink${END}" #>> /tmp/symblelink.out
    #elif [[ -c $j ]]; then
    #    echo -e "$j is a character device" #>> /tmp/char.out
    #elif [[ -b $j ]]; then
    #    echo -e  "$j is a block device" #>> /tmp/block.out
    #elif [[ -p $j ]]; then
    #    echo -e  "$j is a pipe" #>> /tmp/pipefile.out
    #elif [[ -S $j ]]; then
    #    echo -e  "$j is a socket" #>> /tmp/socket.out
    #else 
    #    echo -e  "nothing" &> /dev/null
    #fi
    done
echo "Done."
}

main

