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

> 2.写出输出数字 0 到 100 中 3 的倍数(0 3 6 9...)的命令

```bash
seq 0 3 100
```

> 3.简述 RAID0,RAID1,RAID5 三种 RAID 技术的工作原理及特点

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

> 4.Linux 中的进程有哪几种状态，在 ps 显示出的信息中分别用什么符号表示？

| 运行态 | 可中断睡眠 | 不可中断睡眠 | 停止态 | 僵尸态 |
| ------ | ---------- | ------------ | ------ | ------ |
| R      | S          | D            | T      | Z      |

> [进程和 PS 相关用法移步](http://suosuoli.cn/?p=307)

> 5.简单描述 linux 下如何将一个新添加的物理磁盘做成文件系统,及相应命令.

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

> 6.在 Shell 环境下，如何查看远程 Linux 系统运行了多少时间?

```bash
[root@steve ~]$uptime
 21:46:17 up 9 days,  2:23,  1 user,  load average: 0.00, 0.00, 0.00
[root@steve ~]$last | grep "system boot" | sed -n '1p'
reboot   system boot  5.3.6-1.el7.elre Fri Nov  8 19:22 - 21:46 (9+02:24)
[root@steve ~]$
```

> 7.使用 bash 处理以下文件内容，将域名取出并进行计数排序，如处理:

```bash
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

> 8.除 top 命令外，请再写出查看当前 Linux 系统的状态命令，如 CPU 使用、内存使用、磁盘使用情况等?

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

- (1)从下午 4: 50 删除/abc 目录下的全部子目录和全部文件;
- (2)从早上 8: 00~下午 6: 00 每小时读取/xyz 目录下 x1 文件中每行第一个域的
  全部数据加入到/backup 目录下的 back01.txt 文件内;
- (3)每逢周一下午 5: 50 将/data 目录下的所有目录和文件归档并压缩为文件
  backup.tar.gz;
- (4)在下午 5: 55 将 IDE 接口的 CD-ROM 卸载(假设 CD-ROM 的设备名为 hdc);
- (5)在早上 8: 00 开机后启动

```bash
crontab -e
50 16 * * * /usr/bin/rm /abc/* -rf
0 8-18 * * * /usr/bin/awk '{print $1}' /xyz/x1 >> /backup/back01.txt
50 17 * * mon /usr/bin/tar -zcf /data/backup.tar.gz /data
55 17 * * * /usr/bin/umount /dev/hdc
@reboot   /usr/bin/mount /dev/hdc
```

> 10.Linux 启动大致过程?

```bash
CentOS6:
1.加载BIOS的硬件信息，获取第一个启动设备
2.读取第一个启动设备MBR的引导加载程序(grub)的启动信息
3.加载核心操作系统的核心信息，核心开始解压缩，并尝试驱动所有的硬件设备
4.核心执行init程序，并获取默认的运行信息
5.init程序执行/etc/rc.d/rc.sysinit文件
6.启动核心的外挂模块
7.init执行运行的各个批处理文件(scripts)
8.init执行/etc/rc.d/rc.local
9.执行/bin/login程序，等待用户登录
10.登录之后开始以Shell控制主机

CentOS7:
1.UEFi或BIOS初始化，运行POST开机自检
2.选择启动设备
3.引导装载程序, centos7是grub2
4.加载程序的配置文件：
    /etc/grub.d/
    /etc/default/grub
    /boot/grub2/grub.cfg
5.加载initramfs驱动模块
6.加载内核选项
7.内核初始化，centos7使用systemd代替init
8.执行initrd.target所有单元，包括挂载/etc/fstab
9.从initramfs根文件系统切换到磁盘根目录
10.systemd执行默认target配置，配置文件/etc/systemd/system/default.target
11.systemd执行sysinit.target初始化系统及basic.target准备操作系统
12.systemd启动multi-user.target下的本机与服务器服务
13.systemd执行multi-user.target下的/etc/rc.d/rc.local
14.Systemd执行multi-user.target下的getty.target及登录服务
15.systemd执行graphical需要的服务
```

> 11.简述/et/stab 里面个字段的含义?

```bash
UUID=7b5a4979-194d-419e-802f-df05cd42f592   /boot      ext3         defaults           1 2
设备全局唯一标识符/分区标识                 设备挂载点  文件系统类型   默认的启动加载选项  启动检查顺序
```

> 12.列出 linux 常见打包工具并写相应解压缩参数(至少三种)?

```bash
tar:
tar -Jxf file.tar.xz
tar -jxf file.tar.bz2
tar -zxf file.tar.gz

cpio:
cpio -idv < file.cpio
```

> 13.一个 EXT3 的文件分区，当用 touch 新建文件时报错，错误信息是磁盘已满，但是使用 df 命令查看磁盘空间并不满，为什么?

```bash
inode节点数用尽，提示空间满;此时虽然还有空闲磁盘空间，但是用来记录文件元数据的inode已无法分配，所以无法再创建文件。
```

> 14.请使用 Linux 系统命令统计出 establish 状态的连接数有多少?

```bash
netstat | sed -n '/ESTAB/p' | cut -d " " -f6 | wc -l
```

> 15.mysql 数据库的备份还原是怎么做的?

```bash
物理备份
  直接复制数据文件进行备份，与存储引擎有关，占用较多的空间，速度快
  物理备份的优势：
  1.备份操作简单，直接拷贝需要备份的文件到备份服务器
  2.恢复物理备份亦简单，MyISAM的存储引擎直接放到相应的位置；InnoDB的存储引擎则需要停止MySQL
  服务和其他的简单步骤。
  3.InnoDB和MyISAM的数据库的物理备份可以跨平台、跨操作系统和跨MySQL版本兼容(逻辑备份亦可以)。
  4.恢复物理备份的时间极短，因为MySQL服务器不用执行任何SQL语句或者构建索引；相比逻辑备份来说，
  比较可怕的一点就是无法预估逻辑备份恢复的时间。
  物理备份的劣势：
  1.基于InnoDB数据库的物理备份文件往往远大于相对应的逻辑备份文件。InnoDB的表空间有很多未使用的
  磁盘空间，有部分空间用来实现其他功能而不是存储数据(如：插入缓存，回滚段空间等)
  2.由于文件名大小写敏感和不同的系统浮点数格式不一样等问题，物理备份也不是能够跨所有平台和系统。

逻辑备份
  使用mysqldump备份
    InnoDB存储引擎完全备份:
    mysqldump –uroot -p –A –F –E –R  --single-transaction --master-data=1 --flush-privileges  --triggers --default-character-set=utf8 --hex-blob > ${BACKUP}/fullbak_${BACKUP_TIME}.sql
    MyISAM存引擎完全备份:
    mysqldump –uroot -p –A –F –E –R –x --master-data=1 --flush-privileges  --triggers  --default-character-set=utf8  --hex-blob > ${BACKUP}/fullbak_${BACKUP_TIME}.sql
  还原
    登录数据库使用source ${BACKUP}/fullbak_${BACKUP_TIME}.sql还原数据库
    如果是增量备份和差异备份，则需要注意还原点的位置；还原时关闭二进制日志。

  使用xtrabackup备份
    使用xtrabackup工具备份和还原，大体分三步实现:
    1.备份： 对数据库做完全或增量备份
    xtrabackup --backup --target-dir=/data/backups/
    2.预准备： 还原前，先对备份的数据，整理至一个临时目录;整理后的已经是数据库可用数据
    xtrabackup --prepare --target-dir=/data/backups/或rsync -avrP /data/backup/ /var/lib/mysql/
    3.还原： 将整理好的数据，复制回数据库目录中
    xtrabackup --copy-back --target-dir=/data/backups/
    chown -R mysql:mysql /var/lib/mysql
```

> 16.用一条命令查看目前系统已启动服务所监听的端口?

```bash
netstat -ntulp
ss -ntulp
```

> 17.统计出一台 web server 上的各个状态(ESTABLISHED/SYN_SENT/SYN \_RECV 等)的个数?

```bash
方法一:
netstat -nautlp | awk '{print $6,NF;}' | awk '/[A-Z] /{print $1}' | awk 'BEGIN{printf("%-20s%s\n","STATUS","COUNT")}{count[$0]++}END{for (i in count)printf("%-20s%d\n",i,count[i])}'
方法二:
netstat -ntulp | tr -s " " | cut -d" " -f6 | grep '[A-Z].*[A-Z]$' | sort | uniq -c
```

> 18.查找/usr/local/nginx/logs 目录最后修改时间大于 30 天的文件，并删除?

```bash
find /usr/local/nginx/logs -mtime +30 -exec rm {} \;
```

> 19.添加一条到 192.168.3.0/24 的路由，网关为 192.168.1.254?

```sh
#route add -net 192.168.3.0/24 via 192.168.1.254
```

> 20.利用 sed 命令将 test.txt 中所有的回车替换成空格?

```bash
sed ':L;N;s/\n/ /;tL' test.txt
```

> 21.在每周 6 的凌晨 3:15 执行/home/shell/collect.pl, 并将标准输出和标准错误
> 输出到/dev/null 设备，请写出 crontab 中的语句?

```bash
15 3 * * sat /home/shell/collect.pl &> /dev/null
或
15 3 * * 6 /home/shell/collect.pl &> /dev/null
```

> 22.请写出精确匹配 IPv4 规范的正则表达式?

```bash
\(\([1-9]\?[0-9]\|1[0-9]\{2\}\|2[0-4][0-9]\|25[0-5]\)\.\)\{3\}\([1-9]\?[0-9]\|1[0-9]\{2\}\|2[0-4][0-9]\|25[0-5]\)
```

> 23.匹配文本中的 key,并打印出该行及下面的 5 行?

```bash
grep -En -A 5 'key' file.txt
```

> 24.dmesg 命令中看到 ip\_ conntrack: table full, dropping packet.如何解决?

```bash
调整连接追踪功能所能够容纳的最大连接数量
[root@localhost ~]# cat   /proc/sys/net/netfilter/nf_conntrack_max
65536

1. 加大 nf_conntrack_max 值
vi /etc/sysctl.conf
net.nf_conntrack_max = 393216
net.netfilter.nf_conntrack_max = 393216
2. 降低 nf_conntrack timeout 时间
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_sent
120
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_recv
60
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
432000
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_fin_wait
120
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close
nf_conntrack_tcp_timeout_close       nf_conntrack_tcp_timeout_close_wait
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait
60
[root@localhost ~]# cat /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close
10

[root@localhost ~]# vim /etc/sysctl.conf
net.netfilter.nf_conntrack_tcp_timeout_established = 300
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
[root@localhost ~]# iptables -t nat -L -n
```

> 25.查询 file1 里面空行的所在行号?

```bash
grep -En '^$' file1
```

> 26.查询 file1 以 abc 结尾的行?

```bash
grep -E 'abc$' file1
```

> 27.打印出 file1 文件第 1 到第三行?

```bash
sed -n '1,3p' file1
head -n3 < file1
```

> 28.如何将本地 80 端口的请求转发到 8080 端口，当前主机 IP 为 192.168.2.1?

```bash
iptables -t nat -A PREROUTING -d 192.168.2.1 --dport 80 -j REDIRECT --to-ports 8080
```

> 29.crontab 在 11 月份内，每天的早上 6 点到 12 点，每隔 2 小时执行一次/usr/bin/httpd.sh 怎么实现?

```bash
crontab -e
0 6-12/2 * 11 * /bin/bash /usr/bin/httpd.sh
```

> 30.编写个 shell 脚本将/usr/local/test 目录下大于 100K 的文件转移到/tmp 目录?

```bash
#!/bin/bash
WORKDIR="/usr/local/test/"
if [[ -f ${WORKDIR}* ]]; then
      find ${WORKDIR} -type f -size +100K -exec mv {} /tmp \;
else
      echo "Nothing to do.Exiting..."
      exit
fi
```

> 31.在/var/log 目录下查找文件名以 vmk 开头的文件并打印路径

```bash
[root@node3 ~]# find /var/log -name vmk*
```

> 32.每周日凌晨零点零分定期备份/usr/backup 到/tmp 目录下，普通用户如何操作?

```bash
crontab -e
0 0 * * 0 /usr/bin/cp -a /usr/backup /tmp
```

> 33.有三台 Linux 主机，A, B 和 C; A 上有私钥，B 和 C 上都有公钥，如何做到用
> 私钥从 A 登录到 B 后，可以直接不输密码即可再登录到 C?并写出具体命令行。

```bash

```

> 34.简述多核 CPU 和单核 CPU 的优点和缺点，是否所有程序在多核 CPU 上运行速度都快?为什么?

```bash
多核CPU:相比单核CPU,多核CPU可实现真正意义上的并行处理任务，在处理如渲染、并行计算等任务时优势明显；
但是随着CPU核心增多，单个核心的主频无法做到很高；而且目前很多软件并未对多核心的CPU提供很好的优化(对多线程的支持)。
所以某些软件在多核心的CPU上运行并不会有明显的性能改善，仍然是单核处理该任务，甚至某些时候更适合在主频更高的单核
处理器上运行。
单核CPU:相比多核CPU，单核CPU可以实现更高的主频，对于需要实时处理的任务优势明显，如对3D游戏的实时渲染；高的主频
意味着可以在单位时间内渲染更多的帧。
综上:不是所有程序在多核CPU上运行的速度就快，这取决于程序对于多核特性的支持和多核处理器的每个核心的主频等诸多因素。
```

> 35.脚本实现打印杨辉三角?

> 36.简述 DNS(Domain Name System)域名系统工作原理。

> 37.TCP 和 UDP 协议对比，说明优缺点。

> 38. JVM的内存模型？

```bash
方法区（Method Area）

方法区主要是放一下类似类定义、常量、编译后的代码、静态变量等，在JDK1.7中，HotSpot VM的实现就是将其放
在永久代中，这样的好处就是可以直接使用堆中的GC算法来进行管理，但坏处就是经常会出现内存溢出，
即PermGen Space异常，所以在JDK1.8中，HotSpot VM取消了永久代，用元空间取而代之，元空间直接使用本地
内存，理论上电脑有多少内存它就可以使用多少内存，所以不会再出现PermGen Space异常。

堆（Heap）

几乎所有对象、数组等都是在此分配内存的，在JVM内存中占的比例也是极大的，也是GC垃圾回收的主要阵地，平时
我们说的什么新生代、老年代、永久代也是指的这片区域，至于为什么要进行分代后面会解释。

虚拟机栈（Java Stack）

当JVM在执行方法时，会在此区域中创建一个栈帧来存放方法的各种信息，比如返回值，局部变量表和各种对象引用
等，方法开始执行前就先创建栈帧入栈，执行完后就出栈。

本地方法栈（Native Method Stack）
和虚拟机栈类似，不过区别是专门提供给Native方法用的。

程序计数器（Program Counter Register）
占用很小的一片区域，我们知道JVM执行代码是一行一行执行字节码，所以需要一个计数器来记录当前执行的行数。
```

> 39. JVM垃圾回收算法？

```bash

```