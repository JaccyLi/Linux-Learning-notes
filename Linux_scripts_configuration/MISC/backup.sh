#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-07
#FileName:		    backup.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
DIR="/data/backup/"
echo "Backup starting ..."
sleep 1
cp -av /etc/ ${DIR}etc`date +%F`
echo -e "\e[1;32mBackup finished."
echo -e "The backup file located at : ${DIR} \a\e[0m"
