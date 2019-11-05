#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-29
#FileName:		    national_chess.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		national_chess.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

COLOR_YELLOW="\e[1;;43m"
COLOR_WHITE="\e[1;;47m"
COLOR_END="\e[0m"

n=$3
N=${n:-1}
BOX_HEIGH=$N

W=$1
H=$2
HORIZONTAL_BOX_NUM=${W:-8}
VERTICAL_BOX_NUM=${H:-8}
TOTAL_BOX=$[${VERTICAL_BOX_NUM}*${HORIZONTAL_BOX_NUM}]
HORIZONTAL_BOX_COUNT=0
VERTICAL_BOX_COUNT=0
BOX_HEIGH_COUNT=0
#COUNT=0

#if_specify_size()
#{
#if [[ $# -eq 0 ]]; then
#    echo "Usage:`basename $0` {HORIZONTAL_BOX_NUM VERTICAL_BOX_NUM}"
#    echo "You didn't specify size , default 8X8..."
#    sleep 1
#    echo "Now drawing..."
#    echo 
#    sleep 1
#fi
#}


draw_white()
{
    for ((n=1 ; n <= 2*N ; n++)); do
        echo -en "${COLOR_WHITE} ${COLOR_END}" 
    done
}

draw_yellow()
{
    for ((v=1 ; v <= 2*N ; v++)); do
        echo -en "${COLOR_YELLOW} ${COLOR_END}" 
    done
}

#white_yellow()
#{
#    for ((m=0 ; m < )); do
#        draw_white()
#        draw_yellow()
#    done
#}

#yellow_white()
#{
#
#}

main()
{
#n=$3
#N=${n:-1}
#W=$1
#H=$2
#HORIZONTAL_BOX_NUM=${W:-8}
#VERTICAL_BOX_NUM=${H:-8}
#HORIZONTAL_BOX_COUNT=0
#VERTICAL_BOX_COUNT=0
#TOTAL_BOX=$[${VERTICAL_BOX_NUM}*${HORIZONTAL_BOX_NUM}]
while : ; do




done

}              
            
main           
unset W
unset H
unset n
unset N
unset HORIZONTAL_BOX_NUM
unset VERTICAL_BOX_NUM
unset HORIZONTAL_BOX_COUNT
unset VERTICAL_BOX_COUNT
unset COUNT
