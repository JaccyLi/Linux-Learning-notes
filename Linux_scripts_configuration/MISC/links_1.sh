#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-07
#FileName:		    links_1.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

if [[ $# -gt 0 ]]; then
    FILE=$1
    cat ${FILE} |grep ESTAB | tr -s " " | cut -d" " -f5 | cut -d: -f1 | sort | uniq -c | sort -nr
elif [[ $# -eq 0 ]]; then
    ss -tun |grep ESTAB | tr -s " " | cut -d" " -f6 | cut -d: -f1 | sort | uniq -c | sort -nr

fi

