#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-09-24
#FileName:		    111.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
#!/usr/bin/env bash

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}
sleep12(){
spinner & 
sleep 12  # sleeping for 10 seconds is important work
kill "$!" &> /dev/null # kill the spinner
printf '\n'
}
sleep4(){
spinner &
sleep 4  # sleeping for 10 seconds is important work
kill "$!" &> /dev/null # kill the spinner
printf '\n'
}

echo -n 12
sleep12 & 
