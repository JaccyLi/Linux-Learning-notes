#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    sumspace.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

if [[ $# -eq 2 ]]; then

    F1=`cat $1 | grep "^$" | wc -l`
    F2=`cat $2 | grep "^$" | wc -l`
    echo $(( $F1 + $F2 ))
    
else

echo -e "Please specify two files.\nUsage: `basename $0` file1 file2"

fi

