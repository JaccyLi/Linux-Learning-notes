#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    argsum.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

[[ $# -lt 1 ]] && (echo "Usage:`basename $0` /path/to/somefile" && exit) || grep "^$" $1 | wc -l
