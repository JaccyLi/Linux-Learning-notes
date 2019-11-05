#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    hostping.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

IP="\b(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\b"

[[ $1 =~ $IP ]] && echo "$1 is a legal ip." ||{ echo "$1 is not  a legal ip."; exit 4;} 

ping -c1 -W1 $1 > /dev/null && echo up || echo down

unset IP

