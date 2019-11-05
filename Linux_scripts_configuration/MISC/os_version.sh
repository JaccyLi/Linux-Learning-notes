#!/bin/bash 
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-09-24
#FileName:		    which_version.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

. function_list

VAR=`os_version`

if [[ $VAR -eq 6 ]]; then
    service httpd restart
    service httpd status
else
    systemctl restart httpd
    systemctl status httpd
fi


