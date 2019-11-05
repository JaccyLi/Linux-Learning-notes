#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-31
#FileName:		    log_files_lines.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		log_files_lines.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
#!/bin/bash 
 
# 
 
declare -a files 
 
files=(/var/log/*.log) 
 
declare -i lines=0 
 
for i in $(seq 0 $[${#files[*]}-1]); do 
 
    #if [ $[$i%2] -eq 0 ];then 
 
 
let lines+=$(wc -l ${files[$i]} | cut -d' ' -f1)  
 
    #fi 
 
done 
 
echo "Lines: $lines."
