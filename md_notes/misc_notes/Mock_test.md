

> 1、简述三次握⼿和四次挥⼿？

```bash
（1）第一次握手：Client将标志位SYN置为1，随机产生一个值seq=J，并将该数据包发送给Server，Client进
入SYN_SENT状态，等待Server确认。
（2）第二次握手：Server收到数据包后由标志位SYN=1知道Client请求建立连接，Server将标志位SYN和ACK都
置为1，ack=J+1，随机产生一个值seq=K，并将该数据包发送给Client以确认连接请求，Server进入SYN_RCVD状
态。
（3）第三次握手：Client收到确认后，检查ack是否为J+1，ACK是否为1，如果正确则将标志位ACK置为1，
ack=K+1，并将该数据包发送给Server，Server检查ack是否为K+1，ACK是否为1，如果正确则连接建立成功，
Client和Server进入ESTABLISHED状态，完成三次握手，随后Client与Server之间可以开始传输数据了。

（1）第一次挥手：Client发送一个FIN，用来关闭Client到Server的数据传送，Client进入FIN_WAIT_1状态。
（2）第二次挥手：Server收到FIN后，发送一个ACK给Client，确认序号为收到序号+1（与SYN相同，一个FIN占
用一个序号），Server进入CLOSE_WAIT状态。
（3）第三次挥手：Server发送一个FIN，用来关闭Server到Client的数据传送，Server进入LAST_ACK状态。
（4）第四次挥手：Client收到FIN后，Client进入TIME_WAIT状态，接着发送一个ACK给Server，确认序号为收
到序号+1，Server进入CLOSED状态，完成四次挥手。
```

2、某个⽂件占⽤了过多磁盘空间，rm删掉之后发现空间并没释放，是什么原因？如何解决？

```bash
答：原因是这个文件正在被某个软件占用着。
> /boot/bigfile 释放空间
rm -f /boot/bigfile 删除文件
```

3、⽤cp命令，将/etc/fstab复制到/data/dir，⾄少需要什么权限？

````bash
cp命令 有执行权限
/etc/fstab 读权限
/data/dir 写权限和执行权限
```

4、CentOS7中默认的Shell是什么？其他shell还有什么？（⾄少3种）

```bash
默认bash其他：tcsh、csh、ash、bsh、ksh
```

5、如何在/data⽬录找到⼤于100k的⽂件并删除？
```bash
find /data -type f -size +100k -exec rm {} \;
```

6、如何执⾏history中上⼀条的命令？（⾄少两种）

```bash
使用键盘上方向键一次，并回车执行
输入！！并回车执行
输入！-1并回车执行
按Ctrl+p并回车执行
```

7、⽇志⽂件access.log，内容是时间顺序递增，从0点到23点的所有⽇志记录，每条时间的⽇志为⼀
⾏：
2016/06/12 00:00:00 - - 200 190 http://www.a.com/o1html xxxxxxx
2016/06/12 00:00:01 - - 200 390 http://www.b.com/o1html xxxxxxx
2016/06/12 00:00:02 - - 200 490 http://www.v.com/o.html xxxxxxx
......
2016/06/12 23:59:57 - - 200 131 http://www.9.com/o.html xxxxxxx
2016/06/12 23:59:58 - - 200 489 http://www.r.com/o.net xxxxxxx
2016/06/12 23:59:59 - - 200 772 http://www.w.com/o.php xxxxxxx
（1）打印出07点到8点之间的所有⽇志？
（2）打印出15:30:05到22:45:55之间的所有⽇志？
```bash
sed -n '/2016\/06\/12 07:00:00/,/2016\/06\/12 8:00:00/p' access.log
sed -n '/2016\/06\/12 15:30:05/,/2016\/06\/12 22:45:55/p' access.log
```

8、使⽤rpm命令分别安装、卸载、更新ntp-0.7.rpm软件包？（请写三条命令）

```bash
rpm -ivh ntp-0.7.rpm
rpm -e ntp-0.7.rpm
rpm -U ntp-0.7.rpm
```

9、查出netstat -tn命令中，状态处理ESTABLISHED的远程主机IP 连接数最多的前⼗个IP？

```bash
netstat -na |grep ESTABLISHED$| tr -s " " ":"|cut -d: -f5|sort|uniq -c|sort -nr|head 10
```

10、10.0.0.0/8 全国给32个省份划分各⾃⼦⽹。

```bash
（1）子网掩码？
（2）最小子网，最大子网？
（3）每个子网的主机数？
（4）第20个子网给北京使用，最小ip，最大ip?
请注意：北京是第20个⼦⽹，不是20⼦⽹！
1、子网掩码 255.248.0.0
2、最小子网 10.0.0.0/13 最大子网 10.248.0.0/13
3、每个子网的主机数 2^19-2=52万
4、北京最小ip，最大ip 10.152.0.1 10.159.255.254
```

11、某单位的内部服务器地址是172.22.0.7，⽤户是wang，密码是magedu，请问如何把你本机的脚
本/data/id.sh传送给该服务器的/data/⽂件夹？

```bash
scp /data/id.sh wang@172.22.0.7:/data/
*******continue connecting (yes/no)?yes
*****************password:magedu
(***为省略内容)
```

12、发现⼀台linux主机⽆法上⽹，将做些什么检查和排错？（⾄少3项）

```bash
1、ifconfig查看主机是否有地址
2、ping的地址是否有拼写问题
3、网线是否插好，网络是否畅通
4、service network restart重连网络
5、是否启用了网络防火墙，禁止任何用户访问
```

13、符号链接和硬链接的区别（⾄少3条）？

```bash
符号（或软）链接
    1、一个符号链接指向另一个文件
    2、一个符号链接的内容是它引用文件的名称
    3、可以对目录进行
    4、可以跨分区
    5、指向的是另一个文件的路径
    6、其大小为指向的路径字符串的长度
    7、不增加或减少目标文件inode的引用计数
硬链接
    1、创建硬链接会增加额外的记录项以引用文件
    2、对应于同一文件系统上一个物理文件
    3、每个目录引用相同的inode号
    4、创建时链接数递增
    5、删除文件时：
     rm命令递减计数的链接
     文件要存在，至少有一个链接数
     当链接数为零时，该文件被删除
    6、不能跨越驱动器或分区
```

14、⼀块新硬盘插⼊linux主机后，怎样才能正常使⽤？简要说明主要操作步骤（⾄少3步）？

```bash
答：新硬盘格式化分区制作文件系统后挂载即可使用
第一步：格式化分区用fdisk命令进行
第二步：制作文件系统用mkfs.xfs命令进行
第三步：挂载用mount命令进行
第四步：编辑配置文件/etc/fstab 实现自动挂载
```

15、编写脚本id.sh，计算/etc/passwd⽂件中的第5个⽤户和第9个⽤户和第15⽤户的ID之和。
```bash
[root@magedu ~]# vim id.sh
#！/bin/bash
ip1=`cat /etc/passwd |head -5 | tail -1|cut -d: -f3`
ip2=`cat /etc/passwd |head -9 | tail -1|cut -d: -f3`
ip3=`cat /etc/passwd |head -15 | tail -1|cut -d: -f3`
let sum=ip1+ip2+ip3
echo $sum
```

16、让所有⽤户的PATH“环境变量”的值多出⼀个路径，/usr/local/apache/bin，并让其⽣效？
```
vim /etc/profile
export PATH=/usr/local/apache/bin:$PATH
source /etc/profile 生效
```

17、简述Raid0，1，5、6，10，01的区别？
```
RAID0：连续地分割数据并并行地读/写于多个磁盘上。因此具有很高的数据传输率，但没有数据冗余，并没有提供
数据可靠性，如果一个磁盘失效，将影响整个数据。因此RAID0不可应用于需要数据高可用性的关键应用。最少由2
块磁盘组成，每块都能存储数据。
RAID1：通过数据镜像实现数据冗余，在两对分离的磁盘上产生互为备份的数据。可以提高读的性能，是磁盘阵列
中费用最高的，但提供了最好的数据可用性。当一个磁盘失效，系统可以自动地交换到镜像磁盘上。最少由2块磁
盘组成，只有一半的磁盘能存储数据。
RAID5：所有磁盘轮流充当校验盘，有容错能力，最多准许1块磁盘损坏。最少由3块磁盘组成，充当校验盘的不分
磁盘不能存储数据，实际容量是n-1/n。
RAID6：raid6是再raid5的基础上为了加强数据保护而设计的。可允许损坏2块硬盘。
RAID10：先两两组成RAID1，再组合成RAID0。每组镜像最多损坏一个磁盘，有容错能力。最少由4块磁盘组成，只
有一半的磁盘能存储数据。
RAID01：损坏一块磁盘之后，所在的RAID 0组即认为损坏，RAID 01 实际上已经退化为一个RAID 0的结构，上面
那组RAID 0随便坏一块，整个RAID就崩溃了。
```

18、在卷组VG0中的⼀个逻辑卷lv0，ext4⽂件系统。现发现lv0空间不⾜，需要添加磁盘/dev/sdd为
```
lv0扩容100G，写出相关的操作命令？（⾄少3步）
1 echo -e "n\np\n\n\n+100G\nt\n\n8e\nw\n" |fdisk /dev/sdd
2 pvcreate /dev/sdd #将新硬盘格式化成PV
3 vgextend VG0 /dev/sdd #将PV加入已有的VG卷组
4 lvextend -L +100G /dev/VG0/lv0 #对逻辑卷进行100G扩容
5 resize2fs /dev/VG0/lv0 #必须resize2fs，更新文件系统，否则空间无法识别到
19、简介7层⽹络的分层情况，每⼀层的功能，其中包含的主要协议。
OSI中的层 功能 TCP/IP协议族
答：
应用层 文件传输，电子邮件，文件服务，虚拟终端 TFTP，HTTP，SNMP，FTP，SMTP，DNS，Telnet
表示层 数据格式化，代码转换，数据加密 没有协议
会话层 解除或建立与别的接点的联系 没有协议
传输层 提供端对端的接口 TCP，UDP
网络层 为数据包选择路由 IP，ICMP，RIP，OSPF，BGP，IGMP
数据链路层 传输有地址的帧以及错误检测功能 SLIP，CSLIP，PPP，ARP，RARP，MTU
物理层 以二进制数据形式在物理媒体上传输数据 ISO2110，IEEE802，IEEE802.2
20、显⽰/etc/inittab中以#开头，且后⾯跟着⼀个或多个空⽩字符，⽽后⼜跟了任意⾮空⽩字符的⾏？
（⽅法很多，只要能实现就成）
egrep "^#[ ]+[^ ].*" /etc/inittab

⼆、扩展题：（每题10分，共20分）
1、创建⼀键安装和卸载httpd-2.4.25.tar.gz 的脚本install_httpd.sh,要求安装⾄/app/httpd24⽬录
下，运⾏ httpd.sh install 实现安装，运⾏ httpd.sh remove 实现卸载
```
vim httpd.sh
#!/bin/bash
case $1 in
 "install")
 DIR=/app/httpd24
 echo "Start install httpd ..."
 rpm -q gcc &> /dev/null || yum install gcc -y
 yum groupinstall "development tools" -y
 yum install apr-devel apr-util-devel pcre-devel openssl-devel -y
 wget http://192.168.36.7/httpd-2.4.25.tar.gz
 tar xvf httpd-2.4.25.tar.gz
 cd httpd-2.4.25/
 ./configure --prefix=/app/httpd24 &>/dev/null
 make && make install &>/dev/null
 echo PATH="/$DIR/bin:"'$PATH' > /etc/profile.d/httpd.sh
 . /etc/profile.d/httpd.sh
 echo "Install httpd is successful!"
 ;;
 "remove")
 echo "Start remove httpd ..."
 rm -rf /app/httpd24
 rm -f /etc/profile.d/httpd.sh
 killall httpd
 yum groupremove "development tools" -y
 yum remove apr-devel apr-util-devel pcre-devel openssl-devel -y
 echo "Remove httpd is successful!"
 ;;
 *)
 echo "Usage: `basename $0` install | remove"
 ;;
esac
地址如不通
 wget http://192.168.36.7/httpd-2.4.25.tar.gz
 tar xvf httpd-2.4.25.tar.gz
 cd httpd-2.4.25/
替换为
 wget https://www.apache.org/dist/httpd/httpd-2.4.38.tar.gz
 tar -xvf httpd-2.4.38.tar.gz
 cd httpd-2.4.38/
 ```

2、路由转发实验,要求主机A能ping通主机B，请简要写出每台虚拟机：主机A，路由器R1，路由器R2，
路由器R3和主机B需要完成的配置。
```
主机A地址：192.168.37.123/24 主机B地址：172.16.0.123/16
网段1vmnet1：192.168.37.0/24 网段2vmnet2：10.0.0.0/8
网段3vmnet3：192.168.23.0/24 网段4vmnet4：172.16.0.0/16
路由器R1 eth0：192.168.37.200/24 eth1：10.0.0.100/8
路由器R2 eth0：10.0.0.200/8 eth1：192.168.23.100/24
路由器R3 eth0：172.16.0.200/16 eth1：192.168.23.200/24
例：
关闭所有主机的防火墙。
 [root@magedu ~]# systemctl stop firewalld 临时关闭
 [root@magedu ~]# systemctl disable firewalld 禁止开机启动
关闭所有主机的selinux。
 [root@magedu ~]# vim /etc/sysconfig/selinux
 SELINUX=disabled
关闭NetworkManager
 [root@magedu ~]# service NetworkManager stop
答：
主机A：
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
NAME=eth0
BOOTPROTO=static
IPADDR=192.168.37.123
GATEWAY=192.168.37.200
PREFIX=24
ONBOOT=yes
[root@magedu ~]# service network restart
路由器R1：
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
NAME=eth0
BOOTPROTO=static
IPADDR=192.168.37.200
PREFIX=24
ONBOOT=yes
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
NAME=eth1
BOOTPROTO=static
IPADDR=10.0.0.100
PREFIX=8
ONBOOT=yes
[root@magedu ~]# service network restart
[root@magedu ~]# route add -net 192.168.23.0 gw 10.0.0.200
[root@magedu ~]# echo 1 > /proc/sys/net/ipv4/ip_forward
路由器R2：
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
NAME=eth0
BOOTPROTO=static
IPADDR=10.0.0.200
PREFIX=8
ONBOOT=yes
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
NAME=eth1
BOOTPROTO=static
IPADDR=192 168 23 100
IPADDR=192.168.23.100
PREFIX=24
ONBOOT=yes
[root@magedu ~]# service network restart
[root@magedu ~]# route add -net 172.16.0.0/16 gw 192.168.23.200
[root@magedu ~]# route add -net 192.168.37.0 gw 10.0.0.100
[root@magedu ~]# echo 1 > /proc/sys/net/ipv4/ip_forward
路由器R3：
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
NAME=eth0
BOOTPROTO=static
IPADDR=172.16.0.200
PREFIX=16
ONBOOT=yes
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
NAME=eth1
BOOTPROTO=static
IPADDR=192.168.23.200
PREFIX=24
ONBOOT=yes
[root@magedu ~]# service network restart
[root@magedu ~]# route add -net 10.0.0.0/8 gw 192.168.23.100
[root@magedu ~]# echo 1 > /proc/sys/net/ipv4/ip_forward
主机B：
[root@magedu ~]# vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
NAME=eth0
BOOTPROTO=static
IPADDR=172.16.0.123
GATEWAY=172.16.0.200
PREFIX=16
ONBOOT=yes
[root@magedu ~]# service network restart 
```