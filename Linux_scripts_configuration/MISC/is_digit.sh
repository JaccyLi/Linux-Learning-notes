#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-09-24
#FileName:		    is_digit.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************


is_num()
{
local N_NUM=200
local NUM
read -t 15 -p "Please input a number:" NUM
[[ $NUM =~ ^[0-9]+$ ]] || { echo -e "$NUM is not a number. Exiting...\a" ; exit $N_NUM ;}
echo "$NUM is a number, nice!"
}

is_num

