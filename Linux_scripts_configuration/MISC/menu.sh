#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-10-06
#FileName:		    menu.sh
#URL:		        https://blog.csdn.net/YouOops
#Description:		Test scrpting.
#Copyright (C):	    2019 All rights reserved
#*******************************************************************************
cat <<EOF
1:cookies
2:手撕李逵
3:地三鲜
4:拔丝煎饼
5:鲍鱼
6:烤鱼
7:没了
EOF

read -p "客官您慢选：" S

case $S in 
1)
echo "cooking..."
;;
2)
echo "20RMB."
echo "哟，不好意思，今儿个李逵不在！"
;;
3)
echo "13RMB."
echo "马上给您上地三鲜！"
;;
4)
echo "16RMB."
echo "马上给您上拔丝煎饼！"
;;
5)
echo "30RMB."
echo "马上给您上鲍鱼！"
;;
6)
echo "60RMB."
echo "马上给您上烤鱼！"
;;
7)
echo "不好意思客官，没没了."
;;
*)
echo -e "您究竟吃不吃饭?"
;;
esac
