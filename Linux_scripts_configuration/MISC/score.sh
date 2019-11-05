#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    score.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

read -p "Please input your grade: " G

if [[ ! $G =~ ^[0-9]+$ ]]; then
    echo "Input a number(0-100)."
elif [[ $G -lt 60 ]]; then 
    echo "To low."
elif [[ $G -lt 80 ]]; then 
    echo "Keep going."
elif [[ $G -le 100 ]]; then 
    echo "Very nice!"
else 
    echo "What you did ?"
    echo "Kidding me? You can't get $G."
fi
