#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-17
#FileName:		    list_disks.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		list_disks.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#2、写一个脚本，完成如下功能： 
#(1) 列出当前系统识别到的所有磁盘设备 
#(2) 如磁盘数量为1，则显示其空间使用信息;否则，则显示最后一个磁盘上的空间使用信息 

OS_VER=`cat /etc/redhat-release | sed -nr 's/.*([0-9]+)\.[0-9]+\..*/\1/p'`

if [[ "$OS_VER" -eq 8 ]]
then
DISK="nvme..."
else
DISK="sd."
fi

N=`lsblk | grep -w "$DISK" | wc -l`
SD_1=`lsblk | grep -w "$DISK" | head -n1`
SD_END=`lsblk | grep -w "$DISK" | tail  -n1`

if [ $N -eq 1 ] 
then 

    echo "$SD_1" | tr -s " " : | cut -d: -f1,5

else                                                                                                                                                      

    echo "$SD_END"  | tr -s " " : | cut -d: -f1,5

fi
