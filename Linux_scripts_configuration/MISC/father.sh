#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-09-24
#FileName:		    ttt.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

export NAME=env_val 

name=normal_val


echo "Father is running..,"
sleep 3

echo "NAME=$NAME"
echo "name=$name"


bash /data/scripts/son.sh

