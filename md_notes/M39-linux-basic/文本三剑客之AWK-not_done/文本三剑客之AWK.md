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
1、文件ip_list.txt如下格式，请提取”.magedu.com”前面的主机名部分并写
入到回到该文件中 
 
1 blog.magedu.com 
 
2 www.magedu.com 
 
… 
 
999 study.magedu.com 
2、统计/etc/fstab文件中每个文件系统类型出现的次数 
3、统计/etc/fstab文件中每个单词出现的次数 
4、提取出字符串Yd$C@M05MB%9&Bdh7dq+YVixp3vpw中的所有数字 
5、有一文件记录了1-100000之间随机的整数共5000个，存储的格式
100,50,35,89…请取出其中最大和最小的整数 
6、解决DOS攻击生产案例：根据web日志或者或者网络连接数，监控当某个IP
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