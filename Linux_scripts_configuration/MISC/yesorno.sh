#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-10
#FileName:		    yesorno.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		yesorno.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

read -p "Input yes or no: " ANS

case $ANS in
[Yy][Ee][Ss]|[Yy])
    echo "You'v input yes."
;;
[Nn][Oo]|[Nn])
    echo "You'v input no."
;;
*)
    echo "Ni hao tiao a ."
esac

