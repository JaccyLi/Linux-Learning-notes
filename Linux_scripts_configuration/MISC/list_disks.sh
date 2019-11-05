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

N=`lsblk | grep -w sd. | wc -l`
SD_1=`lsblk | grep -w sd. | head -n1`
SD_END=`lsblk | grep -w sd. | tail  -n1`

if [ $N -eq 1 ]
then 

   lsblk | grep -w sd. | tr -s " " : | cut -d: -f1,5 

else

   lsblk | grep -w sd. | tail -n1 | tr -s " " : | cut -d: -f1,5 

fi
