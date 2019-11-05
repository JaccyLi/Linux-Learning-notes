#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-10
#FileName:		    disk.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

MAX=`df -h | grep -E /dev/\(sd\|nvme\) | egrep -o "[0-9]{,3}%" | cut -d% -f1 | sort -nr | head -n1`

echo "The max usage of space is $MAX(%)."

