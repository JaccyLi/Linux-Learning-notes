#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-31
#FileName:		    change_host_root_passwd.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		change_host_root_passwd.sh
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
#NET="192.168.2"
NET="172.20"
ORIGINAL_PASSWD="123456"

for ((i=0 ; i < 256 ; i++)); do
    for ((j=0 ; j < 256 ; j++)); do
    if [[ $i -lt 10 ]] ; then
        NEW_PASSWD="11100$i"
    elif [[ $i -lt 100 ]]; then 
        NEW_PASSWD="1110$i"
    else
        NEW_PASSWD="111$i"
    fi
#NEW_PASSWD="666666"
expect <<EOF 
set timeout 5
spawn ssh root@${NET}.$i.$j 
expect { 
"yes/no"   { send "yes\n";exp_continue } 
"password" { send "$ORIGINAL_PASSWD\n" } 
} 
expect "]#" { send "echo $NEW_PASSWD | passwd --stdin root\n" }
expect "]#" { send "echo -e \e[1;32mHi,there!!\e[0m" }
expect "]#" { send "exit\n" }
expect eof 
EOF

done
done
