#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-09
#FileName:		    sumfile.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

RAW=`tree -L 1 -d /var/ /etc/ /usr/ | wc -l`
echo "The dirsum is : $(( $RAW - 3 ))"
