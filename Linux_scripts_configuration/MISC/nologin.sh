#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-09
#FileName:		    nologin.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

if [ -f /etc/nologin ]; then
    echo "File exists,nobody but root now can login."
else
    echo System maintenance,deny login! > /etc/nologin
fi

