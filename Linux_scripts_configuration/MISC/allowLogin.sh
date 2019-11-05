#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-09
#FileName:		    allowLogin.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
if [ -f /etc/nologin ]; then 
    /usr/bin/rm /etc/nologin
else
    echo "Everyone can login."
fi

