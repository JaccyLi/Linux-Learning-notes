#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-28
#FileName:		    print_equicrural_triangle.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		print_equicrural_triangle.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#RANDOM_SEED=$(($RANDOM%7))
#COLOR="\e[1;$((${RANDOM_SEED}+31))m"
COL_END="\e[0m"
read -p "Input the size of triangle:" N
while sleep 0.1; do
tput clear
for ((i=0 ; i < N ; i++)); do
    for ((j=N ; j >= i ; j--)); do
        echo -n " "
    done
    for ((j=0 ; j <= i ; j++)); do
        COLOR="\e[1;5;$((${RANDOM_SEED}+31))m"
        echo -ne "${COLOR}*${COL_END}"
        echo -n " "
        RANDOM_SEED=$(($RANDOM%7))
    done
    echo 
done
tput cup 0 0
tput cup $N 0
read -p "按Enter键换颜色;按\"q\"退出:" Q
if [[ "$Q" = "q" ]]; then
    exit
fi

done
