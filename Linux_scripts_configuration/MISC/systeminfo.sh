#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    systemInfoForCentos678.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Show some sys info.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

R_SEED=$(( $RANDOM%7+31 )) 
COLOR_START="\e[1;${R_SEED}m"
COLOR_END="\e[0m"

echo -e "The hostname is:              ${COLOR_START}`hostname`. ${COLOR_END}"

echo -e "IPV4 addr is:                 ${COLOR_START}`ifconfig | egrep -o '([0-9]{1,3}\.){3}[0-9]{,3}' |head -n1` ${COLOR_END}"

echo -e "The OS version is:            ${COLOR_START}`cat /etc/redhat-release | egrep -o '[0-9]+\.[0-9]+(\.[0-9]+)?'` ${COLOR_END}"

echo -e "The kernel version is:        ${COLOR_START}` uname -r `. ${COLOR_END}"

echo -e "The CPU model is:            ${COLOR_START}`lscpu | egrep Model\ name | tr -s " " | cut -d: -f2` ${COLOR_END}"


free -h |grep "Mem" | tr -s " " |cut -d" "  -f2,4 > /tmp/total_free 
TOTAL=`cat /tmp/total_free | cut -d" "  -f1`
FREE=`cat /tmp/total_free | cut -d" "  -f2`
 
echo -e "The total online memory is:   ${COLOR_START}$TOTAL(${FREE} free)${COLOR_END}"
 

echo -e  "\nHarddisk usage:             ${COLOR_START} \n\n`df -h | egrep -e /dev/sd -e /dev/nvme` ${COLOR_END}"

unset R_SEED COLOR_START COLOR_END
unset TOTAL FREE


