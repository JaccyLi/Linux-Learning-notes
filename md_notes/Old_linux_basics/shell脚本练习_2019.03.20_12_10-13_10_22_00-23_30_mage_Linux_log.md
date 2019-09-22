@[TOC](练习)
###### 练习1:
传递三个餐宿给脚本，第一个为整数，第二个为算术运算符，打三个为整数；将其计算结果显示出来，要求保留两位小数。
```shell
#!/bin/bash
#
if [ $# -ne 3 ];then
echo "Usage: ./arithmetic.sh ARG1 ARG2 ARG3"
else
bc <<< "sacle=2;$1$2$3"
echo bc
```
#echo "scale=2;111/22;" | bc
#bc <<< "scale=2;111/22;"

###### 练习2:
给脚本传递三个参数，判断其中的最大数和最小数，并显示出来。
```shell
MAX=0
if MAX -lt $1
MAX=$1
if MAX -lt $2
MAX=$2
echo MAX
```
###### 练习3:
传递三个参数给脚本，参数均为用户名，将此用户账户信息读取出来后放置于/tmp/testusers.txt中，并要求每一行行首有行号。
```shell
#!/bin/bash
#
$LINE1=id $1
$LINE2=id $2
$LINE3=id $3
echo "1 $LINE1" >> /tmp/testusers
echo "2 $LINE2" >> /tmp/testusers
echo "3 $LINE3" >> /tmp/testusers
```
###### 练习4:
写一个脚本，依次向/etc/passwd中的每一个用户问好，并且显示对方的shell。统计一共有多少个用户。形如：
Hello ， root , your shell is :/bin/bash
扩展：只向默认shell为bash的用户问好。
```shell
#!/bin/bash
#
LINES=\`wc -l /etc/passwd | cut -d' ' -f1\`
for I in \`seq 1 $LINES\`;do 
echo "Hello, \`head -n $I /etc/passwd | tail -1 | cut -d: -f1`"
```
###### 练习5:
添加10个用户user1到user10，密码同用户名；要求只有用户不存在的情况才能添加。
扩展：接受一个参数：
add：添加用户user1..user10
del:删除用户user1..user10


###### 练习6:
计算100以内所有能被3整除的正整数的和：
取模、取余：%
3%2=1
100%55=45


###### 练习7:
计算100 以内所有奇数的和以及所有偶数的和：分别显示之；


###### 练习8:

写一个脚本，分别显示当前系统上所有默认shell为bash的用户和默认shell为/sbin/nologin的用户，并显示各类shell下的用户总数，显示结果形如：
BASH,3users,they are:
root,redhat,gentoo
NOLOGIN,2users,they are:
bin,ftp


