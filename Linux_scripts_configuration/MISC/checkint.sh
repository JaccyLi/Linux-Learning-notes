#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    checkint.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************


PATTERN="^([^-]|[0-9]+)?[0-9]+$"

if [[ $1 =~ $PATTERN ]]; then
    echo "$1 is a unsigned int."
else
    echo "$1 is not a unsigned int."
fi
