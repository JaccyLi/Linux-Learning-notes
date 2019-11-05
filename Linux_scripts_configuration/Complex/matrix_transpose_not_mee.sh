#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-11-02
#FileName:		    matrix_transpose.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		matrix_transpose.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#NUMS=([00]=1 [01]=2 [02]=3 [10]=4 [11]=5 [12]=6 [20]=7 [21]=8 [22]=9) 
#ORDER=3 
     
read -p "Please input the size of marix: " ORDER
generate_matrix () 
{ 
for ((i=0;i<ORDER;i++));do 
    for ((j=0;j<ORDER;j++));do 
        echo -e "${NUMS[$i$j]} \c" 
    done 
    echo 
done 
} 
 
echo -e "The original matrix is :\t" 
 
generate_matrix 
 

for ((i=0;i<ORDER;i++));do 
    for ((j=i;j<ORDER;j++));do 
        if [ $i -ne $j ];then 
            TMP_NUMS=${NUMS[$i$j]} 
            NUMS[$i$j]=${NUMS[$j$i]} 
            NUMS[$j$i]=$TMP_NUMS 
        fi 
    done 
done 
echo -e "Transposed matix is: \t" 
 
generate_matrix 
