<center> <font face="黑体" size=6 color=grey>文本三剑客之AWK-详细介绍</font></center>

# 

## awk介绍 

## awk基本用法

## awk变量

## awk格式化

## awk操作符 

## awk条件判断 

## awk循环 

## awk数组 

## awk函数 

## 调用系统命令

## 练习

1、文件ip_list.txt如下格式，请提取".magedu.com"前面的主机名部分并写回到该文件中 
```
1 blog.magedu.com
2 www.magedu.com
…
999 study.magedu.com
```

- solution

```bash
产生文件记录再实验：
[root@centos7 ~]#seq 100 > 1
[root@centos7 ~]for ((i=0;i<100;i++));do echo "`echo $RANDOM`.`echo $RANDOM`.`echo $RANDOM`" ;done > 2
[root@centos7 ~]paste -d" " 1 2 > ip_list.gen
[root@centos7 ~]awk -F" +|[.]" '{print $2}END{printf("\n")}' < ip_list.gen  >> ip_list.gen
使用题目文件：
[root@centos7 /data/interview_solutions]#cat ip_list.txt 
1 blog.magedu.com
2 www.magedu.com
...
999 study.magedu.com
[root@centos7 /data/interview_solutions]awk -F" +|[.]" '{print $2}END{printf("\n")}' < ip_list.txt  >> ip_list.txt
[root@centos7 /data/interview_solutions]#cat ip_list.txt 
1 blog.magedu.com
2 www.magedu.com
...
999 study.magedu.com
blog
www

study
```

2、统计/etc/fstab文件中每个文件系统类型出现的次数

```bash
[root@centos8 /mnt/data/linux-5.3.8]#cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Tue Sep 24 22:18:02 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
UUID=4eb8e865-b250-4d37-bc0b-b586dd0445fa /                       xfs     defaults        0 0
UUID=b1e47c34-eeae-43ca-b058-afda45663929 /boot                   ext4    defaults        1 2
UUID=32e5fa6b-f7a1-4736-a914-73217675d4d9 /data                   xfs     defaults        0 0
UUID=284edd6b-1c11-4c18-af07-0959ee08f989 swap                    swap    defaults        0 0

[root@centos8 /mnt/data/linux-5.3.8]#awk '/^UUID/{fs[$3]++}END{for (f in fs){printf("%2-d%s\n",fs[f],f)}}' < /etc/fstab
1 swap
1 ext4
2 xfs
```

3、统计/etc/fstab文件中每个单词出现的次数

```bash
[root@centos7 /data/interview_solutions]#awk -v RS=" +|[/.,':=-]|[#]|[\n]" -F" +" 'BEGIN{print "NUM","WORD"}{for(i=0;i<NF;i++){word[$1]++}}END{for (j in word){printf("%4-d%s\n",word[j],j)}}' < /etc/fstab  | sort

1   After
1   anaconda
1   and
1   are
1   b058
1   b1e47c34
1   b250
1   b586dd0445fa
1   bc0b
1   blkid(8)
1   boot
1   Created
1   daemon
1   data
1   dev
1   disk
1   editing
1   eeae
1   etc
1   ext4
1   f7a1
1   filesystems
1   findfs(8)
1   for
1   from
1   fstab
1   fstab(5)
1   generated
1   info
1   maintained
1   man
1   more
1   mount(8)
1   on
1   or
1   pages
1   reference
1   reload
1   run
1   See
1   Sep
1   systemctl
1   systemd
1   to
1   Tue
1   under
1   units
1   update
2   by
2   file
2   swap
2   this
2   xfs
4   defaults
4   UUID
6   0
NUM WORD
```

4、提取出字符串Yd$C@M05MB%9&Bdh7dq+YVixp3vpw中的所有数字 

```bash
[root@centos7 /data/interview_solutions]#echo "Yd$C@M05MB%9&Bdh7dq+YVixp3vpw" | tr 'a-z' 'A-Z' | awk -F "[A-Z]|[%&@+]" '{for (i=1;i<=NF;i++){print $i}}' | tr -s "\n"
```

5、有一文件记录了1-100000之间随机的整数共5000个，存储的格式
100,50,35,89…请取出其中最大和最小的整数 

```bash

```

6、解决DOS攻击生产案例：根据web日志或者或者网络连接数，监控当某个IP
并发连接数或者短时内PV达到100，即调用防火墙命令封掉对应的IP，监控频
率每隔5分钟。防火墙命令为：iptables -A INPUT -s IP -j REJECT 

7、将以下文件内容中FQDN取出并根据其进行计数从高到低排序 
http://mail.magedu.com/index.html 
http://www.magedu.com/test.html 
http://study.magedu.com/index.html 
http://blog.magedu.com/index.html 
http://www.magedu.com/images/logo.jpg 
http://blog.magedu.com/20080102.html 
8、将以下文本以inode为标记，对inode相同的counts进行累加，并且统计出
同一inode中，beginnumber的最小值和endnumber的最大值 
inode|beginnumber|endnumber|counts| 
106|3363120000|3363129999|10000| 
106|3368560000|3368579999|20000| 
310|3337000000|3337000100|101| 
310|3342950000|3342959999|10000| 
310|3362120960|3362120961|2| 
311|3313460102|3313469999|9898| 
311|3313470000|3313499999|30000| 
311|3362120962|3362120963|2| 
输出的结果格式为： 
310|3337000000|3362120961|10103| 
311|3313460102|3362120963|39900| 
106|3363120000|3368579999|30000| 