#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    chick_rabbit.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
 
## heads=37 feet=94
read -p "Input the number of heads: " H
read -p "Input the number of feet: " F


let R_L_F=$F-$H-$H
R_FEET=$(($R_L_F * 2))

R=$(( $R_FEET / 4 ))

C=$(( $H - $R )) 

echo "There are $R rabbits."
echo "There are $C chicken."

