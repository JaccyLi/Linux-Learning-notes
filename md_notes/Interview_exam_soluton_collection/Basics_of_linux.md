> 1.写出下面公认的服务所使用的四层协议类型和相应的端口号：

```bash
FTP服务协议:TCP/UDP             端口号:21
DNS服务协议:UDP                 端口号:53
DHCP服务协议:UDP                端口号:67、68
Telnet服务协议:TCP/UDP          端口号:23
HTTP服务协议:TCP/UDP/SCTP       端口号:80
POP3服务协议:TCP/UDP            端口号:110
```

- 扩展

```bash
HTTPS:TCP/UDP/SCTP:443
SMTP:TCP/UDP:25
IMAP:TCP/UDP:143
SSH:TCP/UDP/SCTP:22
MYSQL:TCP/UDP:3306
SQLserver:TCP/UDP:1433
oracle:TCP/UDP:152
```

> 2.写出输出数字0到100中3的倍数(0 3 6 9...)的命令

```bash
seq 0 3 100
```

> 3.简述RAID0,RAID1,RAID5三种RAID技术的工作原理及特点

```bash
1.RAID0:RAID0将同一个文件分为多个相同大小的数据块(条带卷,strip)，分别按顺序存储在RAID0
所部属的物理磁盘上，其提高了I/O性能，但是无法实现冗余。磁盘空间利用率为
100%，实现RAID0最少需要两块磁盘。
2.RAID1:RAID1简单的说就是备份一份文件作为镜像(镜像卷,mirror)，RAID1上的各物理磁盘所对应
的同一个扇区存储的是同一个文件的某部分，其实现了冗余，但是I/O性能有所下
降。磁盘空间利用率为50%,实现RAID1最少需要2两块磁盘(或者不是最少时2N块磁盘)。
3.RAID5:RAID5使用数据校验技术来提供某一块磁盘损坏后恢复数据(最多只能损坏一块磁盘),使用至少
三块物理磁盘来部属RAID5，其中的数据校验结果均匀的存放在不同的磁盘，允许任意一块磁盘损坏。其
空间利用率为:((N-1)/N)%
```

> 4.Linux中的进程有哪几种状态，在ps显示出的信息中分别用什么符号表示？

|运行态|可中断睡眠|不可中断睡眠|停止态|僵尸态|
|---|---|---|---|---|
|R|S|D|T|Z|

> [进程和PS相关用法移步](http://suosuoli.cn/?p=307)

> 5.简单描述linux下如何将一个新添加的物理磁盘做成文件系统,及相应命令.

```bash
1.识别硬盘
[root@centos7 ~]for i in /sys/class/scsi_host/host*/scan; do echo "- - -" > $i ; done
[root@centos7 ~]#lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
...
sdd         8:48   0  500G  0 disk
...
2.分区
[root@centos7 ~]echo -e "n\np\n\n\n+200G\nt\n\n8e\nw\n" |fdisk /dev/sdd1
3.通知内核更新分区
[root@centos7 ~]centos5/7:partprobe
[root@centos7 ~]centos6: partx -a  /dev/sdd1
4.创建文件系统
[root@centos7 ~]mkfs.ext4 /dev/sdd1
5.挂载
[root@centos7 ~]mkdir -p /data/log
[root@centos7 ~]mount /dev/sdd1 /data/log
6.添加新硬盘到/etc/fstab文件
echo "/dev/sdd1      /data/log     ext4     defaults  0  0" >> /etc/fstab
```

> 6.在Shell环境下，如何查看远程Linux系统运行了多少时间?

> 7.使用bash处理以下文件内容，将域名取出并进行计数排序，如处理:

```
http://www.baidu.com/index.html
htp://www.baidu.com/1.html
http://post.baidu.com/index.html
htp://mp3.baidu.com/index.html
http://post.baidu.com/2.html
http://www.baidu.com/3.html
处理结果：
域名的出现的次数  域名
3 www.baidu.com
2 post.baidu.com
1 mp3.baidu.com
```

```bash
方法一:
[root@centos7 /data/interview_solutions]#cat url
http://www.baidu.com/index.html
htp://www.baidu.com/1.html
http://post.baidu.com/index.html
htp://mp3.baidu.com/index.html
http://post.baidu.com/2.html
http://www.baidu.com/3.html
[root@centos7 /data/interview_solutions]#sed -nr 's#.*/(.*)/.*#\1#p' url  | sort | uniq -c | sort -nr
      3 www.baidu.com
      2 post.baidu.com
      1 mp3.baidu.com

方法二:
[root@centos7 /data/interview_solutions]#cat url 
http://www.baidu.com/index.html
htp://www.baidu.com/1.html
http://post.baidu.com/index.html
htp://mp3.baidu.com/index.html
http://post.baidu.com/2.html
http://www.baidu.com/3.html
[root@centos7 /data/interview_solutions]#awk -F"/" '{url[$3]++}END{for(i in url){printf("%-d %s\n",url[i] ,i)}}' url | sort -nr
3 www.baidu.com
2 post.baidu.com
1 mp3.baidu.com

方法三：
[root@centos7 /data/interview_solutions]#cat url 
http://www.baidu.com/index.html
htp://www.baidu.com/1.html
http://post.baidu.com/index.html
htp://mp3.baidu.com/index.html
http://post.baidu.com/2.html
http://www.baidu.com/3.html
[root@centos7 /data/interview_solutions]#cut -d/ -f3 < url | sort | uniq -c | sort -nr
      3 www.baidu.com
      2 post.baidu.com
      1 mp3.baidu.com

```

> 8.除top命令外，请再写出查看当前Linux系统的状态命令，如CPU使用、内存使用、磁盘使用情况等?

```bash
1.free      # 显示内存空间和交换空间使用情况
2.htop      # 查看系统进程和资源
3.vmstat    # 查看虚拟内存信息
4.iotop     # 监控I/O使用情况
5.iostat    # 查看CPU和设备I/O信息
6.iftop     # 显示带宽使用情况
7.pmap      # 显示某进程对应的内存映射
8.dstat     # 替代vmstat和iostat统计系统资源
```

> 9.某系统管理员需要每天做一定的重复工作，编制一个解决方案:

- (1)从下午4: 50删除/abc目录下的全部子目录和全部文件;
- (2)从早上8: 00~下午6: 00 每小时读取/xyz目录下x1文件中每行第一个域的
全部数据加入到/backup目录下的back01.txt 文件内;
- (3)每逢周一下午5: 50将/data 目录下的所有目录和文件归档并压缩为文件
backup.tar.gz;
- (4)在下午5: 55将IDE接口的CD-ROM卸载(假设CD-ROM的设备名为hdc);
- (5)在早上8: 00开机后启动

```bash

```

> 10.Linux 启动大致过程?

```bash

```

> 11.简述/et/stab里面个字段的含义?

```bash

```

> 12.列出linux常见打包工具并写相应解压缩参数(至少三种)?
> 13.一个EXT3的文件分区，当用touch新建文件时报错，错误信息是磁盘已满，但是使用df命令查看磁盘空间并不满，为什么?
> 14.请使用Linux系统命令统计出establish状态的连接数有多少?
> 15.mysql数据库的备份还原是怎么做的?
> 16.用一条命令查看目前系统已启动服务所监听的端口?
> 17.统计出一台web server上的各个状态(ESTABLISHED/SYN_SENT/SYN _RECV
等)的个数?
> 18.查找/usr/local/nginx/logs 目录最后修改时间大于30天的文件，并删除?
> 19.添加一条到192.168.3.0/24的路由，网关为192.168.1.254?
> 20.利用sed命令将test.txt中所有的回车替换成空格?
> 21.在每周6的凌晨3:15执行/home/shell/collect.pl, 并将标准输出和标准错
误输出到/dev/null设备，请写出crontab中的语句?
> 22.请写出精确匹配IPv4规范的正则表达式?
> 23.匹配文本中的key,并打印出该行及下面的5行?
> 24.dmesg命令中看到ip_ conntrack: table full, dropping packet.如何解决?
> 25.查询file1里面空行的所在行号?
> 26.查询file1以abc结尾的行?
> 27.打印出file1文件第1到第三行?
> 28.如何将本地80端口的请求转发到8080端口，当前主机IP为192.168.2.1?
> 29.crontab在11月份内，每天的早上6点到12点中，每隔2小时执行一次/usr/bin/httpd.sh怎么实现?
> 30.编写个shell脚本将/usr/ocal/test目录下大于100K的文件转移到/tmp目录?
> 31.有三台Linux主机，A, B和C, A上有私钥，B和C上都有公钥，如何做到用私钥从A登录到B后，可以直接不输密码即可再登录到C?并写出具体命令行。
> 32