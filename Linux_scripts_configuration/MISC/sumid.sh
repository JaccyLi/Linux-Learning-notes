#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    sumid.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************

id1=`cat /etc/passwd | head -n10 | tail -n1 | cut -d: -f3`
id2=`cat /etc/passwd | head -n20 | tail -n1 | cut -d: -f3`


let sum=$id1+$id2


echo $sum
