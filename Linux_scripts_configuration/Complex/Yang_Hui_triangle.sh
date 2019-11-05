#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-11-03
#FileName:		    Yang_Hui_triangle.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Yang_Hui_triangle.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
#     1
#    1 1
#   1 2 1
#  1 3 3 1
# 1 4 6 4 1
#1 5 10 10 5 1

read -p "Please input the order of yanhui triangle: " ORDER
for (( i=0 ; i < ORDER ; i++)); do
    
    echo
done

read -p "输入高度" g         #g是最高行 
declare -a a 
for i in `seq $g`           #$i是当前行 
do 
 
if [ $i -eq 1 ] 
 
then 
 
 
for o in `seq $[$g-$i]` 
 
 
do 
 
 
 
echo -n "   " 
 
 
done 
 
 
a[1]=1 
 
 
echo  "1" 
 
 
continue 
 
fi 
 
for j in `seq $i` #j表示当前行的第几个数字 
 
do               
 
 
if [ $j -eq 1 ] 
 
 
then 
 
 
 
for o in `seq $[$g-$i]` 
 
 
 
do 
 
 
 
 
echo -n "   " 
 
 
 
done 
 
 
 
echo -n "1" 
 
 
 
a[$i$j]=1 
 
 
elif [ $j -eq $i ] 
 
 
then 
 
 
 
echo -n "     1" 
 
 
 
a[$i$j]=1 
 
 
else 
 
 
 
let  a[$i$j]=${a[$[i-1]$[j-1]]}+${a[$[i-1]$[j]]} 
 
 
 
echo -n "     ${a[$i$j]}" 
 
 
 
fi 
 
done 
echo 
done 
