#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-31
#FileName:		    Bubble_sort.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Bubble_sort.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
COL_GREEN="\e[1;32m"
COL_END="\e[0m"

declare -a NUMS
declare -i num=0

while :; do
    read -p "Input num(q:quit|s:sort):" N

    if [[ $N =~ ^[0-9]+$ ]]; then
        NUMS[${#NUMS[*]}]=$N
        echo -e "All nums are now:\n${NUMS[@]}"
    else
        if [[ "$N" = "q" ]]; then
            break
        elif [[ "$N" = "s" ]]; then
            # sort here
            #while [[ "$num" -lt "${#NUMS[*]}" ]]; do 
            for ((n=0 ; n < ${#NUMS[*]} ; n++)); do
                for ((i=0 ; i < ${#NUMS[*]} ; i++)); do
                    for (( j=i ; j < ${#NUMS[*]}-i-1 ; j++)); do
                        if [[ ${NUMS[j]} -lt  ${NUMS[$[j+1]]} ]]; then
                            MID=${NUMS[$[j+1]]} 
                            NUMS[$[j+1]]=${NUMS[j]}
                            NUMS[j]=$MID
                        fi
                    done
                done
            done

            echo -e "${COL_GREEN}Sorted nums are${COL_END}:\n${NUMS[@]}"
        else
            echo -e "$N is not a number,please reinput(q:quit):\a"
            continue
        fi
    fi

    #if [[ "$N" = "q" ]]; then
    #    break
    #elif [[ "$N" = "s" ]]; then
    #    for ((i=0 ; i < ${#NUMS[*]} ; i++)); do
    #        if [[ ${NUMS[i]} -lt  ${NUMS[$[i+1]]} ]]; then
    #            MID=${NUMS[$[i+1]]} 
    #            NUMS[$[i+1]]=${NUMS[i]}
    #            NUMS[i]=$MID
    #        fi
    #    done
    #    echo -e "Sorted nums are:\n${NUMS[@]}"
    #else
    #    continue
    #fi

    #if [[ "$N" = "s" ]]; then
    #    for ((i=0 ; i < ${#NUMS[*]} ; i++)); do
    #        if [[ ${NUMS[i]} -lt  ${NUMS[$[i+1]]} ]]; then
    #            MID=${NUMS[$[i+1]]} 
    #            NUMS[$[i+1]]=${NUMS[i]}
    #            NUMS[i]=$MID
    #        fi
    #    done
    #    echo -e "Sorted nums are:\n${NUMS[@]}"
    #fi
done
