<center> <font face="黑体" size=6 color=grey>Shell脚本编程进阶</font></center>

# 一.循环

# 二.信号捕捉

# 三.函数

# 四.数组

# 五.高级字符串操作

# 六.高级变量

# 七.expect


# 八.练习

> 1.判断/var/目录下所有文件的类型

法一：

```bash
#!/bin/sh 
for i in $(find /var) ;do  
    if [ -b $i ];then
        echo "$i是块设备"  
    elif [ -c $i ] ;then   
        echo "$i是字符设备" 
    elif [ -f $i ];then   
        echo "$i是普通文件"  
    elif [ -h $i ];then   
        echo "$i是符号链接文件"  
    elif [ -p $i ];then   
        echo "$i是管道文件"  
    elif [ -S $i ];then   
        echo "$i是套接字文件"  
    elif [ -d $i ];then   
        echo "$i是目录文件"  
    else 
        echo "文件或目录不存在"  
    fi 
done 
exit 0
```

法二：

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-27
#FileName:          indicate_file_type.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       indicate_file_type.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
GREEN="\e[32m"
CYAN="\e[36m"
END="\e[0m"
indicate ()
{
NUM=$#
declare -i J=0
if [ -f /tmp/mid ]; then
    : > /tmp/mid
fi
echo "$*" | tr -s " " "\n" >> /tmp/mid
exec 6< /tmp/mid
for ((j=0 ; j<=$NUM ; j++)); do
while read -u 6 I; do
        let J+=1
        if [ -d $I ]; then
            echo -e "File $i is a ${GREEN}dir${END}." > /tmp/dir.log
        else
            C=$(echo $(ls -l $I) | cut -c1)
            if [[ "$C" = "-" ]]; then
                echo -e  "File $i is a normal file." > /tmp/normal.log
            #elif [[ "$C" = "d" ]]; then
            #    echo "File$J is a directory."
            elif [[ "$C" = "b" ]]; then
                echo -e  "File $i is a block device file." > /tmp/block.log
            elif [[ "$C" = "c" ]]; then
                echo -e  "File $i is a character device file." > /tmp/char.log
            elif [[ "$C" = "l" ]]; then
                echo -e  "File $i is a ${CYAN}symble link${END}." > /tmp/symble.log
            elif [[ "$C" = "p" ]]; then
                echo -e  "File $i is a pipe."
            elif [[ "$C" = "s" ]]; then
                echo -e  "File $i is a socket."
            else
                echo "File or dir not exists."
            fi  
        fi  
done
done
}

main()
{
echo "Indicating..."
for i in `find /var/` ; do
    indicate $i
done
echo "Done."
}

main

```

> 2.添加10个用户user1-user10，密码为8位随机字符

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-28
#FileName:          add_10_user.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       add_10_user.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
. /etc/init.d/functions
# success
# failure
# passed
# warning

for ((i=1 ; i<=10 ; i++)); do
    if id user${i} &> /dev/null; then
        echo user$i exists.
        continue
    else
        useradd user$i 
        PASS=` echo $RANDOM | md5sum | cut -c1-8`
        echo $PASS | passwd --stdin user$i &> /dev/null
        echo "user$i created.`success`"
    fi  
done

```

> 3./etc/rc.d/rc3.d目录下分别有多个以K开头和以S开头的文件；分别读取每个文件，以
K开头的输出为文件加stop，以S开头的输出为文件名加start，如K34filename stop  
S66filename start

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-28
#FileName:          srffix_start_stop.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       srffix_start_stop.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

for FILE in `ls /etc/rc.d/rc3.d`; do
    SIGN=`echo $FILE | cut -c1`
    if [[ "S" = "$SIGN" ]]; then
        #echo "\"$FILE\" add suffix is \"$FILE stop\"."
        echo "$FILE start"
    elif [[ "K" = "$SIGN" ]]; then
        #echo "\"$FILE\" add suffix is \"$FILE start\"."
        echo "$FILE stop"
    else
        echo "Wrong."
    fi  
done
```

> 4.编写脚本，提示输入正整数n的值，计算1+2+…+n的总和

```bash
#!/bin/bash
read -p "please input a unsigned int:" N
SUM=0
for ((i=1 ; i <= N ; i++)); do
    let SUM+=i
done
echo Sum is $SUM

```

> 5.计算100以内所有能被3整除的整数之和

```bash
#!/bin/bash
SUM=0
read -p "input a unsigned int:" N
for ((i=0 ; i <= $N ; i++)); do
    if [[ $(($i%3)) -eq 0 ]]; then
        let SUM+=i
    fi
done
echo "Sum is $SUM."
```

> 6.编写脚本，提示请输入网络地址，如192.168.0.0，判断输入的网段中主机在线状态 

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-28
#FileName:          ping_specific_network.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       ping_specific_network.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
. /etc/init.d/functions
# success
# failure
# passed
# warning

NET="192.168"

for ((i=1 ; i <= 255 ; i++)); do
    for ((j=1 ; j <= 255 ; j++)); do
        if ping -W1 -c1 ${NET}.${i}.$j &> /dev/null ; then
            echo "Host ${NET}.$i.$j is UP. `success`"
        else
            echo "Host ${NET}.$i.$j is DOWN. `warning`"
        fi  
    done
done

```

> 7.打印九九乘法表 

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:                        steveli
#QQ:                            1049103823
#Data:                      2019-10-28
#FileName:                  2_9X9.sh
#URL:                   https://blog.csdn.net/YouOops
#Description:           2_9X9.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#1x1=1
#2x1=2   2x2=4
#3x1=3   3x2=6   3x3=9


for i in {1..9}; do 
    for j in $(seq $i); do
    let RESULT=$(($i*$j))
       # for k in "3 4"; do
       #     if [[ $i -eq $k ]] && [[ $j -eq 2 ]]; then
       #         echo -en "|${i}x$j=$RESULT   "
       #     fi
       # done
    echo -en "|${i}x$j=$RESULT\t"
    done
    echo
done
```

> 8.在/testdir目录下创建10个html文件,文件名格式为数字N（从1到10）加随机8个字母，
如：1AbCdeFgH.html 

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-28
#FileName:          create_random_file_name.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       create_random_file_name.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#1AbCdeFgH.html 

for ((i=1 ; i <= 10 ; i++)); do
    mkdir -p ~/testdir/$i$(cat /dev/random | tr -cd [:alpha:]  | head -c8).html
done
```

> 9.打印等腰三角形 

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:                        steveli
#QQ:                            1049103823
#Data:                      2019-10-28
#FileName:                  print_equicrural_triangle.sh
#URL:                   https://blog.csdn.net/YouOops
#Description:           print_equicrural_triangle.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
#RANDOM_SEED=$(($RANDOM%7))
#COLOR="\e[1;$((${RANDOM_SEED}+31))m"
COL_END="\e[0m"
read -p "Input the size of triangle:" N
while sleep 0.1; do
tput clear
for ((i=0 ; i < N ; i++)); do
    for ((j=N ; j >= i ; j--)); do
        echo -n " "
    done
    for ((j=0 ; j <= i ; j++)); do
        COLOR="\e[1;5;$((${RANDOM_SEED}+31))m"
        echo -ne "${COLOR}*${COL_END}"
        echo -n " "
        RANDOM_SEED=$(($RANDOM%7))
    done
    echo 
done
tput cup 0 0
done
```

10、猴子第一天摘下若干个桃子，当即吃了一半，还不瘾，又多吃了一个。第二天早上
又将剩下的桃子吃掉一半，又多吃了一个。以后每天早上都吃了前一天剩下的一半零一
个。到第10天早上想再吃时，只剩下一个桃子了。求第一天共摘了多少？

```bash
#!/bin/bash
#
#*******************************************************************************
#Author:                        steveli
#QQ:                            1049103823
#Data:                      2019-10-28
#FileName:                  monk_eat_peach.sh
#URL:                   https://blog.csdn.net/YouOops
#Description:           monk_eat_peach.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#
LAST=1
for (( I=1 ; I<=9 ; I++ )); do
let LAST=$(( LAST + 1 ))*2
done
echo $LAST
```

> 11.编写脚本，利用变量RANDOM生成10个随机数字，输出这个10数字，并显示其中的最大值和最小值

```bash
#!/bin/bash
i=0
MAX=$RANDOM
MIN=$RANDOM
while [[ $i -lt 10 ]]; do
    if (( MAX >= MIN )); then
        :
    else
        MID=$MAX
        MAX=$MIN
        MIN=$MID
    fi  
    let i++
done
echo MAX=$MAX
echo MIN=$MIN
```
> 12.编写脚本，实现打印国际象棋棋盘 

```bash

```

> 13.后续六个字符串：efbaf275cd、4be9c40b8b、44b2395c46、f8c8873ce0、b902c16c8b、
ad865d2f63是通过对随机数变量RANDOM随机执行命令：echo $RANDOM|md5sum|cut –c1-10
后的结果，请破解这些字符串对应的RANDOM值

```bash

```

> 14.

```bash

```

```bash

```
```bash

```
```bash

```
```bash

```

> 编写服务脚本/root/bin/testsrv.sh，完成如下要求 
(1) 脚本可接受参数：start, stop, restart, status  
(2) 如果参数非此四者之一，提示使用格式后报错退出 
(3) 如是start:则创建/var/lock/subsys/SCRIPT_NAME, 并显示“启动成功” 
考虑：如果事先已经启动过一次，该如何处理？ 
(4) 如是stop:则删除/var/lock/subsys/SCRIPT_NAME, 并显示“停止完成” 
考虑：如果事先已然停止过了，该如何处理？ 
(5) 如是restart，则先stop, 再start 
考虑：如果本来没有start，如何处理？ 
(6) 如是status, 则如果/var/lock/subsys/SCRIPT_NAME文件存在，则显示“SCRIPT_NAME is 
running...”，如果/var/lock/subsys/SCRIPT_NAME文件不存在，则显示“SCRIPT_NAME is 
stopped...” 
(7)在所有模式下禁止启动该服务，可用chkconfig 和 service命令管理 
说明：SCRIPT_NAME为当前脚本名 

```bash
#!/bin/bash
#
#*******************************************************************************               
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-29
#FileName:          testsrv.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       testsrv.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

COLOR_GREEN="\e[1;32m"
COLOR_RED="\e[1;31m"
COLOR_END="\e[0m"
DIR="/var/lock/subsys"
SCR="service"

. /etc/init.d/functions
# success
# failure
# passed
# warning

if [[ ! $1 ]]; then
    echo -e "Usage:`basename $0` {${COLOR_GREEN}start|stop|restart|status${COLOR_END}}"
fi

start()
    {
    if [[ ! -f $DIR/`basename $0` ]]; then
        mkdir -p $DIR &> /dev/null
        touch $DIR/`basename $0` &> /dev/null
        echo "Start Succeeded.`success`"
    else
        echo "Already Started.`passed`"
    fi  
    }
stop()
    {
    if [[ -f $DIR/`basename $0` ]]; then
        rm $DIR/`basename $0` &> /dev/null
        echo "Stop completed."
    else
        echo "Already Stopped.`passed`"
    fi
    }

restart()
    {
    if [[ -f $DIR/`basename $0` ]]; then
        rm $DIR/`basename $0` &> /dev/null
        sleep 0.5
        touch $DIR/`basename $0` &> /dev/null
        echo "Restart Succeeded.`success`"
    else
        echo "It's Stopped.Now starting...`passed`"
        touch $DIR/`basename $0` &> /dev/null
        sleep 0.5
        echo "Start Succeeded.`success`"
    fi
    }

status()
    {
    if [[ -f $DIR/`basename $0` ]]; then
        echo -e "`basename $0` is active.${COLOR_GREEN}[RUNNING]${COLOR_END}"
    else
        echo -e "`basename $0` is inactive.${COLOR_RED}[STOPPED]${COLOR_END}" 
    fi
    }
case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    restart
    ;;
status)
    status
    ;;
*) 
    if [[ $1 ]]; then
    echo -e "Usage:`basename $0` {${COLOR_GREEN}start|stop|restart|status${COLOR_END}}"
    else 
    :
    fi
    ;;
esac 
```

> 编写脚本/root/bin/copycmd.sh 
(1) 提示用户输入一个可执行命令名称 
(2) 获取此命令所依赖到的所有库文件列表 
(3) 复制命令至某目标目录(例如/mnt/sysroot)下的对应路径下  
     如：/bin/bash ==> /mnt/sysroot/bin/bash;/usr/bin/passwd ==> /mnt/sysroot/usr/bin/passwd 
(4) 复制此命令依赖到的所有库文件至目标目录下的对应路径下：  如：/lib64/ld-linux-x86-64.so.2 ==> /mnt/sysroot/lib64/ld-linux-x86-64.so.2 
(5)每次复制完成一个命令后，不要退出，而是提示用户键入新的要复制的命令，并重复完成上述功能；直到用户输入
quit退出

```bash
#. /etc/init.d/functions
# success
# passed
# wrning
# failure

COLOR_GREEN="\e[1;32m"
COLOR_END="\e[0m"
DEST_DIR="/mnt/sysroot"
while :; do
read -p "Please input the command you wanna move(q:quit):" CMD 
    if [[ "$CMD" = "q" ]]; then
        exit
    fi  
    CMD_FULL_PATH=`which --skip-alias $CMD`
    #echo CMD_FULL_PATH=$CMD_FULL_PATH
    CMD_DESTDIR=`dirname $CMD_FULL_PATH`
    #echo CMD_DESTDIR=$CMD_DESTDIR
    CMD_MOVED=`basename $CMD_FULL_PATH`
    #echo CMD_MOVED=$CMD_MOVED
    if [[ ! -d ${DEST_DIR}${CMD_DESTDIR} ]]; then
        mkdir -p ${DEST_DIR}${CMD_DESTDIR} &> /dev/null
    else
        cp -a $CMD_FULL_PATH ${DEST_DIR}$CMD_DESTDIR
    fi  

    SO_LIST=`ldd "$CMD_FULL_PATH" | sed -nr 's#.* (/.*) .*#\1#p'`
    for SO_FILE in $SO_LIST; do
        SO_FULL_PATH=`echo $SO_FILE`
        SO_DESTDIR=`dirname $SO_FILE`
        SO_REAL=$(basename `ls -l $SO_FILE | sed -nr 's#.* (.*)#\1#p'`)
        if [[ ! -d ${DEST_DIR}${SO_DESTDIR} ]]; then
            mkdir -p ${DEST_DIR}${SO_DESTDIR} &> /dev/null
        else
            cp -a ${SO_DESTDIR}/${SO_REAL} ${DEST_DIR}${SO_DESTDIR}
#            echo "$SO_FILE -> ${SO_DESTDIR}${SO_REAL} moved to ${DEST_DIR}${SO_DESTDIR}." 
        fi  
    done
    echo -e "Command ${COLOR_GREEN}$CMD${COLOR_END} and corresponding libs moved to dir /mnt/sysroot/"
done
```

> 斐波那契数列又称黄金分割数列，因数学家列昂纳多·斐波那契以兔子繁殖为例子而引入，故又称为“兔子数列”，指的
是这样一个数列：0、1、1、2、3、5、8、13、21、34、……，斐波纳契数列以如下被以递归的方法定义：
F（0）=0，F（1）=1，F（n）=F(n-1)+F(n-2)（n≥2） 利用函数，求n阶斐波那契数列.

```bash

#!/bin/bash
#
#*******************************************************************************
#Author:            steveli
#QQ:                1049103823
#Data:              2019-10-28
#FileName:          Fibonacci.sh
#URL:               https://blog.csdn.net/YouOops
#Description:       Fibonacci.sh
#Copyright (C):     2019 All rights reserved
#*******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)
#*******************************************************************************
#

#f(n)=f(n-1) + f(n-2)

fibonacci()
{
local a=0
local b=1
LENGTH="$1"
    for ((i=0 ; i<LENGTH ; i++)); do
        echo "$a"
        let fa=$((a+b))
        let a=$b
        let b=$fa
    done
}

fibonacci $1
```
