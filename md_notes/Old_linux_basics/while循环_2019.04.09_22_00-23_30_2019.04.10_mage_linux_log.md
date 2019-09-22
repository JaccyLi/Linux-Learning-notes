@[TOC](while循环)
## while循环
适用于循环次数未知的场景，要有退出条件
语法：
```shell
while CONDITION; do
	statement 
	...
	done
```
### 练习
计算100以内所有正整数的和
```shell
#!/bin/bash
#100sum.sh
declare -i I=1
declare -i SUM=0

while [ $I -le 100 ]; do
        let SUM+=$I
        let I++
done

echo $SUM
```
运行结果：
```bash
[root@MiWiFi-R3A-srv scripts]# ./100sum.sh 
5050
```
### 练习
写一个脚本，用户输入一个字符串将其转换为大写；若输入为quit，则退出；
```shell
#!/bin/bash
#lowtoup.sh
read -p "Input something:" STRING

while [ $STRING != 'quit' ]; do
        echo $STRING | tr 'a-z' 'A-Z'
        read -p "Input something:" STRING
done
```
运行结果：
```bash
[root@MiWiFi-R3A-srv scripts]# ./lowtoup.sh 
Input something:stevenux
STEVENUX
Input something:hello
HELLO
Input something:quit
[root@MiWiFi-R3A-srv scripts]# 
```
### 练习
写一个脚本，检测某用户登录
```shell

#!/bin/bash
#
who | grep "testuser" &> /dev/null
RETVAL=$?

while [ $RETVAL -ne 0 ]; do
        echo "`date`,testuser is not log in."
        sleep 5
        who | grep "testuser" &> /dev/null
        RETVAL=$?
done

echo "testuser is logged in."

```
验证结果：
![while循环检测用户登录与否](https://img-blog.csdnimg.cn/20190409234701717.png)
### 练习
写一个脚本，根据选项显示相应的磁盘信息
```shell
#!/bin/bash
#showdisk.sh
cat <<EOF
D|d)show disk usages;
M|m)show memory usages;
S|s)show Swap usages.
EOF
read -p "Your choice:" CHOICE
case $CHOICE in 
D | d)
	echo "Disk usage:"
	df -Ph ;;
M | m)
	echo "Memory usages:"
	free -m | grep -B 1 Mem ;;
S | s)
	echo "Swap usage:"
	free -m | grep -B 1 Swap;;
*)
	echo "Unknown."
	exit 9;;
esac	
```
运行结果
```bash
lisuo@wcsbackup:~$ ./showdisk.sh 
D|d)show disk usages;
M|m)show memory usages;
S|s)show Swap usages.
Your choice:D
Disk usage:
Filesystem                      Size  Used Avail Use% Mounted on
udev                            7.8G     0  7.8G   0% /dev
tmpfs                           1.6G   33M  1.6G   3% /run
/dev/mapper/wcsbackup--vg-root  901G  5.9G  849G   1% /
tmpfs                           7.8G     0  7.8G   0% /dev/shm
tmpfs                           5.0M     0  5.0M   0% /run/lock
tmpfs                           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda2                       473M   65M  385M  15% /boot
/dev/sda1                       511M  3.4M  508M   1% /boot/efi
tmpfs                           1.6G     0  1.6G   0% /run/user/1000
lisuo@wcsbackup:~$ ./showdisk.sh 
D|d)show disk usages;
M|m)show memory usages;
S|s)show Swap usages.
Your choice:d
Disk usage:
Filesystem                      Size  Used Avail Use% Mounted on
udev                            7.8G     0  7.8G   0% /dev
tmpfs                           1.6G   33M  1.6G   3% /run
/dev/mapper/wcsbackup--vg-root  901G  5.9G  849G   1% /
tmpfs                           7.8G     0  7.8G   0% /dev/shm
tmpfs                           5.0M     0  5.0M   0% /run/lock
tmpfs                           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda2                       473M   65M  385M  15% /boot
/dev/sda1                       511M  3.4M  508M   1% /boot/efi
tmpfs                           1.6G     0  1.6G   0% /run/user/1000
lisuo@wcsbackup:~$ ./showdisk.sh 
D|d)show disk usages;
M|m)show memory usages;
S|s)show Swap usages.
Your choice:q
Unknown.
```
写一个脚本，根据选项显示相应的磁盘信息,不退出版

```shell
#!/bin/bash
#showdisk.sh
cat <<EOF
D|d)show disk usages;
M|m)show memory usages;
S|s)show Swap usages;
*)quit
EOF
read -p "Your choice:" CHOICE
while [ $CHOICE != 'quit' ]; do
	case $CHOICE in 
	D | d)
		echo "Disk usage:"
		df -Ph ;;
	M | m)
		echo "Memory usages:"
		free -m | grep -B 1 Mem ;;
	S | S)
		echo "Swap usage:"
		free -m | grep -B 1 Swap;;
	*)
		echo "Unknown."
	esac	
read -p "Again,your choice:" CHOICE
done
```
运行结果
```bash
lisuo@wcsbackup:~$ ./showdisk2.sh 
D|d)show disk usages;
M|m)show memory usages;
S|s)show Swap usages.
Your choice:D
Disk usage:
Filesystem                      Size  Used Avail Use% Mounted on
udev                            7.8G     0  7.8G   0% /dev
tmpfs                           1.6G   33M  1.6G   3% /run
/dev/mapper/wcsbackup--vg-root  901G  5.9G  849G   1% /
tmpfs                           7.8G     0  7.8G   0% /dev/shm
tmpfs                           5.0M     0  5.0M   0% /run/lock
tmpfs                           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda2                       473M   65M  385M  15% /boot
/dev/sda1                       511M  3.4M  508M   1% /boot/efi
tmpfs                           1.6G     0  1.6G   0% /run/user/1000
Again,your choice:d
Disk usage:
Filesystem                      Size  Used Avail Use% Mounted on
udev                            7.8G     0  7.8G   0% /dev
tmpfs                           1.6G   33M  1.6G   3% /run
/dev/mapper/wcsbackup--vg-root  901G  5.9G  849G   1% /
tmpfs                           7.8G     0  7.8G   0% /dev/shm
tmpfs                           5.0M     0  5.0M   0% /run/lock
tmpfs                           7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda2                       473M   65M  385M  15% /boot
/dev/sda1                       511M  3.4M  508M   1% /boot/efi
tmpfs                           1.6G     0  1.6G   0% /run/user/1000
Again,your choice:S
Swap usage:
Mem:          15944         421       10905          33        4617       15398
Swap:         16279           0       16279
Again,your choice:quit
```


