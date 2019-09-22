@[TOC](<center><font size=214 face=黑体 color=grey> linux初学者小命令 </font></center>)


# 一.在正式学习linux命令之前需要先认识一下linux环境中命令是如何被执行的
-  shell是一个属于linux内核的软件，在系统启动后加载进RAM(内存)内，每个用户通过终端登录系统后，就会运行。负责不间断的接收用户的输入，通过创建新的‘进程’来运行用户输入的命令，执行完后再次返回等待新的命令输入。
> **进程**：进程是一个具有一定独立功能的程序在一个数据集上的一次动态执行的过程,是操作系统进行资源分配和调度的一个独立单位,是应用程序运行的载体。 

- 例如:下面我们先执行了pwd命令，bash就打印了目前用户所处的位置（此处为/root文件夹）；接着执行了ls命令，bash接着显示了当前/root目录下的所有可见文件夹和文件（linux下的隐藏文件以点.开头，使用'ls -a'可以看到）,下面使用*号表示匹配D开头的所有文件与文件夹。 
```bash
[root@centos7 ~]$pwd
/root
[root@centos7 ~]$ls
anaconda-ks.cfg  Desktop  Documents  Downloads  initial-setup-ks.cfg  Music  Pictures  Public  Templates  Videos
[root@centos7 ~]$ls D*
Desktop:
Documents:
Downloads:
```
> ### bash执行命令的过程，以'ls'命令为例:  
第一步.**读取输入信息**：shell通过STDIN(标准输入)的getline()函数得到用户的输入信息(命令ls)并保存其到一个字符串中（“ls”）。然后字符串被解析存储在一个数组内（类似{“ls”，“NULL”}），该数组就存储了内核执行该命令的所有信息。  
第二步.**判断别名**：shell在搜索该命令前会先查看命令别名（用户自定义的命令别名）。如果ls是某个命令的别名，则shell直接执行ls。  
第三步.**判断是否是built-in**：shell检查该命令是否是shell内置的命令（随shell一同加载到内存，随时准备运行），如果是内置命令则直接在shell自己的上下文环境中运行该命令。   
第四步.**在hash中查找**：如果某个非内部命令已经执行过，则该命令的访问路径被记录在hash中，shell下次运行该命令时就无须再去PATH环境变量所记录的文件夹下搜索该命令的执行文件。   
第五步.**在PATH环境变量中查找**：如果命令不是shell内置命令，则shell会去PATH环境变量所代表的文件路径下去查找该命令的可执行二进制文件。找到后shell会复制自己的某些上下文配置，生成一个子shell进程来运行该命令，此时正在运行命令的shell为子shell进程，之前输入命令的shell为父进程。

- **PATH**:在linux中PATH环境变量用来存储包含可执行二进制文件的文件夹，这些文件夹名使用分号:隔开，如下面我电脑上的PATH环境变量存储了字符串"/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/",这字符串说明我的linux中所有非内置的命令都在这些分号隔开的文件夹下。
```bash
[root@centos7 ~]$echo $PATH
/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```
- 下面就列出了/usr/bin/这个文件夹下的一部分可执行文件
- PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:**/usr/bin**:/root/
```bash
[root@centos7 ~]$ls /usr/bin/
[                                    diff                          gtk-query-immodules-2.0-64   mmount                     python2.7                swig
a2p                                  diff3                         gtk-query-immodules-3.0-64   mmove                      qdbus                    sx
abrt-action-analyze-backtrace        diff-jars                     gtk-update-icon-cache        mobj_dump                  qemu-ga                  sync
abrt-action-analyze-c                diffpp                        gtroff                       modifyrepo                 qemu-img                 synclient
abrt-action-analyze-ccpp-local       diffstat                      gucharmap                    modutil                    qemu-io                  syndaemon
abrt-action-analyze-core             dig                           gunzip                       mokutil                    qemu-nbd                 sy
```
-  shell执行命令过程简而言之：
> ### 别名--->内部命令--->hash记录的外部命令--->$PATH
----
# 二.Linux初学的小命令
> ## [alias] 定义或者显示别名
 - 用法：
```bash
> alias [alias-name[=string] ...]
```
```bash
EXAMPLES 
        1. Change ls to give a columnated, more annotated output:

           alias ls="ls -CF"

        2. Create a simple "redo" command to repeat previous entries in the command history file:

           alias r='fc -s'

        3. Use 1K units for du:

           alias du=du\ -k

        4. Set up nohup so that it can deal with an argument that is itself an alias name:

           alias nohup="nohup "
```

> ## [bc] 计算器

- bc是一种支持任意精度数字的带有交互执行语句的语言,在linux中可以使用bc进行交互式的数学计算，其包含很多数学计算的表达式和用法，简单示例如下：
```bash
[root@centos7 ~]$bc
bc 1.06.95
Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
1+1
2
2*3
6
4/5
0
5/4
1
3%5
3
```

> ## [cat] 拼接文件并打印
- 拼接文件并在标准输出上打印文件内容,用法：  
```bash
> cat [OPTION]... [FILE]..
```

- 不带参数或者跟一个减号(-)表示将标准输入复制打印给标准输出  

```bash
[root@centos7 ~]$cat    # cat - 也可以
123                     # 输入123，回车
123                     # 回车后标准输入（123）被打印到标准输出
ABC
ABC
hello world
hello world
^C                      # ctrl + c 强制退出
[root@centos7 ~]$
```

- 带参数

> -A, --show-all 
 > > 等同于 -vET，显示Tab控制符^I和行结束符

```bash
[root@centos7 /data]$cat -vET
gg
gg$                         #标注输入为gg
gg	
gg^I$                       #标准输入为gg和tab键
                            #无标准输入，按enter键
$
ddff		                
ddff^I^I$                   #标准输入为ddff和两个tab键
```

> -b, --number-nonblank
> > 记录非空输入的行号
 
```bash
[root@centos7 /data]$cat -b
123
     1	123            #第一次标准输入内容
222
     2	222            #第二次标准输入内容
asdfw
     3	asdfw
dfbsg4
     4	dfbsg4
3242g
     5	3242g

                        #标准输入为空，未记录
ffff
     6	ffff






fffff
     7	fffff
```
> -e    
> > 等同于 -vE

> -E, --show-ends
> > 显示每行的换行符$

> -n, --number
> > 显示所有的标准输出行

```bash
[root@centos7 /data]$cat -n
hello
     1	hello
hi
     2	hi
whats up
     3	whats up
nothing
     4	nothing

     5	                         # 第五次标准输入无输入，也记录行号
	
     6		
```

> -s, --squeeze-blank
> > 压缩重复的空白行，第一个空白行以后的空白行无输入时不显示任何内容（$也不显示）在标准输出，
> 
```bash
[root@centos7 /data]$cat -sA
dd
dd$
ddff	
ddff^I$

$                                  # 第一个空白行的输出
                                   # 后面的空白行被压缩，换行符$也不显示
                                   # 同上
```

> -t
> > 等同于 -vT  
> -T, --show-tabs
> > 显示 TAB 字符为^I  
 
> -u
> > 忽略tab键和换行符

> -v, --show-nonprinting
> > 显示不可打印字符，配合-E,-T使用，如:cat -vET

> cat后没有跟文件或者跟横杆 - (减号)，则表示读取标准输入

> ## [cd] 切换工作文件夹
- cd命令为shell built-in类型，属于bash内置命令，用于切换用户工作目录，例如：

```bash
[root@centos7 /data/test]$pwd
/data/test                                   # 当前所处位置
[root@centos7 /data/test]$cd /               # / 表示系统根目录 
[root@centos7 /]$pwd
/
[root@centos7 /]$ls                          # 显示根目录文件
bin  boot  data  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@centos7 /]$cd -                        # cd - 表示切换到前一个工作目录 
/data/test
[root@centos7 /data]$cd ~                    # cd ~ 表示切换到家目录
[root@centos7 ~]$cd /data/
[root@centos7 /data]$cd ..                   # cd .. 表示切换到目前所处目录的父目录
[root@centos7 /]$cd .                        # . 一个点表示当前目录
[root@centos7 /]$
```

> ## [df] 报告文件系统磁盘空间使用情况
- 不带参数默认df显示所有文件系统的空间使用情况
```bash
[root@centos7 ~]$df
Filesystem     1K-blocks    Used Available Use% Mounted on
devtmpfs          747304       0    747304   0% /dev
tmpfs             763104       0    763104   0% /dev/shm
tmpfs             763104   10516    752588   2% /run
tmpfs             763104       0    763104   0% /sys/fs/cgroup
/dev/sda2      104806400 5169652  99636748   5% /
/dev/sda3       52403200   32996  52370204   1% /data
/dev/sda1        1038336  171704    866632  17% /boot
tmpfs             152624      12    152612   1% /run/user/42
tmpfs             152624       0    152624   0% /run/user/0
```
> 默认df以1K的块大小为显示单位，
> >  显示的单位大小获取顺序：--block-size(用户指定)-->DF_BLOCK_SIZE-->BLOCK_SIZ-->BLOCKSIZE-->1024 bytes (或者当POSIXLY_CORRECT变量已经被设置时使用512 bytes)

> -a, --all
> > 显示所有文件系统，包括不可访问的

> -B, --block-size=SIZE
> > 指定显示单位大小
```
SIZE is an integer and optional unit (example: 10M is 10*1024*1024).  
Units are K, M, G, T, P, E, Z, Y (powers of 1024) or KB, MB, ... (powers of 1000).
```

>  -h, --human-readable
> > 使用便于人类阅读的格式显示空间大小(e.g.：1K 234M 2G)，此时1M=1024K

> -H, --si
> > 同-h，只不过此时1M=1000K，用此选项数值偏大

> -i, --inodes
> > 不显示空间使用情况，显示inode的使用情况
```bash
[root@centos7 ~]$df -i
Filesystem       Inodes  IUsed    IFree IUse% Mounted on
devtmpfs         186826    402   186424    1% /dev
tmpfs            190776      1   190775    1% /dev/shm
tmpfs            190776    921   189855    1% /run
tmpfs            190776     16   190760    1% /sys/fs/cgroup
/dev/sda2      52428800 162818 52265982    1% /
/dev/sda3      26214400      5 26214395    1% /data
/dev/sda1        524288    340   523948    1% /boot
tmpfs            190776      9   190767    1% /run/user/42
tmpfs            190776      1   190775    1% /run/user/0
```
> -k     
> > 等同于 --block-size=1K

> -l, --local
> > 限制只显示本地文件系统

> -T
> > 显示文件系统
```bash
[root@centos7 ~]$df -T
Filesystem     Type     1K-blocks    Used Available Use% Mounted on
devtmpfs       devtmpfs    747304       0    747304   0% /dev
tmpfs          tmpfs       763104       0    763104   0% /dev/shm
tmpfs          tmpfs       763104   10516    752588   2% /run
tmpfs          tmpfs       763104       0    763104   0% /sys/fs/cgroup
/dev/sda2      xfs      104806400 5169704  99636696   5% /
/dev/sda3      xfs       52403200   32996  52370204   1% /data
/dev/sda1      xfs        1038336  171704    866632  17% /boot
tmpfs          tmpfs       152624      12    152612   1% /run/user/42
tmpfs          tmpfs       152624       0    152624   0% /run/user/0
```

> -t , --type=TYPE
> > 显示特定文件系统的空间使用情况

```bash
[root@centos7 ~]$df -t tmpfs
Filesystem     1K-blocks  Used Available Use% Mounted on
tmpfs             763104     0    763104   0% /dev/shm
tmpfs             763104 10516    752588   2% /run
tmpfs             763104     0    763104   0% /sys/fs/cgroup
tmpfs             152624    12    152612   1% /run/user/42
tmpfs             152624     0    152624   0% /run/user/0
[root@centos7 ~]$df -t xfs
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda2      104806400 5169704  99636696   5% /
/dev/sda3       52403200   32996  52370204   1% /data
/dev/sda1        1038336  171704    866632  17% /boot
```

> -x, --exclude-type
> > 显示非指定的文件系统
```bash
[root@centos7 ~]$df -x tmpfs          # 显示除了tmpfs以外的文件系统
Filesystem     1K-blocks    Used Available Use% Mounted on
devtmpfs          747304       0    747304   0% /dev
/dev/sda2      104806400 5169704  99636696   5% /
/dev/sda3       52403200   32996  52370204   1% /data
/dev/sda1        1038336  171704    866632  17% /boot
```

> ## [free] 显示系统内存使用情况

- 默认显示系统空闲内存和已经使用内存的总量、交换空间使用情况及内核的缓存使用情况。该命令显示的信息都是解析/proc/meminfo文件得到的。用法：

```bash
> free [options]
```
```bash
[root@centos7 ~]$free
              total        used        free      shared  buff/cache   available
Mem:        1526208      509240      640412       12744      376556      841456
Swap:       3145724           0     3145724
```
- 选项：
>  -b, --bytes
> > 一字节为单位显示.
> 
> -k, --kilo
> > 以千字节为单位，默认选用.

> -m, --mega
> > 以兆字节为单位显示

> -g, --giga
> > 以千兆字节为单位显示.
> 
> > --tera 以T为单位.
> 
> > --peta 以P为单位.
>
> -h, --human
> > 以适合人类阅读的大小合适的单位显示

>  -w, --wide
> > 使用宽格式，分开显示buffer和cache，类似centos6
```bash
[root@centos7 ~]$free -w
              total        used        free      shared     buffers       cache   available
Mem:        1526208      763656      116976       19932          40      645536      576160
Swap:       3145724         264     3145460
```
 
> ## [hash]  加速外部命令访问的技术
- 每次执行外部命令时，某命令的完整路径会被hash通过搜索$PATH中的文件夹而记录。如果某命令运行多次，则会命中hash缓存的命令访问信息，此时bash不再搜索$PATH,可以直接找到该命令并运行。

```bash
> hash [-lr] [-p filename] [-dt] [name]
```

> hash -r
> > -r 使用该选项清空hash表，以防移动某些外部命令后，bash任然搜索hash表中的路径，找不到命令。

> hash -t
> > 该选项使得后面跟的多个命令的名字打印在其完整路径名前

```bash
[root@centos7 ~]$hash -t tr ls
tr      /usr/bin/tr
ls      /usr/bin/ls
```

> hash -l
> > 该选项使得打印出来的格式可用于输入用途

```hash
[root@centos7 ~]$hash -l
builtin hash -p /usr/bin/tr 
builtin hash -p /usr/bin/ls 
```

> ## [hostname] 查看和显示主机名

> hostname [新主机名]
> > 该操作在下次重启电脑后失效，编辑/etc/hostname文件永久生效

> hostname -d
> 
> hostname -f
> 
> hostnaem -i
```bash
[root@centos7 /var/www/html]$hostname -f
centos7.magedu.steve
[root@centos7 /var/www/html]$hostname -i
fe80::43be:3721:e7cd:b3a3%ens33 192.168.142.136 192.168.122.1
[root@centos7 /var/www/html]$hostname -d
magedu.steve
```
> ## [lscpu] 打印cpu架构相关的信息
> lscpu [-a|-b|-c|-J] [-x] [-y] [-s directory] [-e[=list]|-p[=list]]
> 
> lscpu -h|-V

> ## [lsblk] 列出块设备相关信息
- 该命令通过sysfs收集的文件系统信息列出当前系统可用的块设备，默认情况下该命令以树状结构打印所有块设备(不含RAM)。
- 用法：
```bash
       -a, --all
              包含空设备.  (By default they are skipped.)

       -b, --bytes
              制指定SIZE栏的单位.

       -D, --discard
              打印关于每个设备丢弃功能(修剪、取消映射)的信息.

       -d, --nodeps
              不打印隶属于该设备的设备信息.  For example, lsblk --nodeps /dev/sda prints information about the sda device only.
               \```
               [root@centos7 ~]$lsblk --nodeps /dev/sda
               NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
               sda    8:0    0  200G  0 disk 
               [root@centos7 ~]$lsblk /dev/sda         
               NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
               sda      8:0    0  200G  0 disk 
               ├─sda1   8:1    0    1G  0 part /boot
               ├─sda2   8:2    0  100G  0 part /
               ├─sda3   8:3    0   50G  0 part /data
               ├─sda4   8:4    0    1K  0 part 
               └─sda5   8:5    0    3G  0 part [SWAP]
               ```
       -f, --fs
              Output info about filesystems.  This option is equivalent to -o NAME,FSTYPE,LABEL,MOUNTPOINT.  The authoritative information about filesystems  and
              raids is provided by the blkid(8) command.

       -h, --help
              Print a help text and exit.

       -I, --include list
              Include devices specified by the comma-separated list of major device numbers.  The filter is applied to the top-level devices only.

       -i, --ascii
              Use ASCII characters for tree formatting.

       -l, --list
              Produce output in the form of a list.

       -m, --perms
              Output info about device owner, group and mode.  This option is equivalent to -o NAME,SIZE,OWNER,GROUP,MODE.

       -n, --noheadings
              Do not print a header line.

       -o, --output list
              Specify which output columns to print.  Use --help to get a list of all supported columns.

              The default list of columns may be extended if list is specified in the format +list (e.g. lsblk -o +UUID).

       -P, --pairs
              Produce output in the form of key="value" pairs.  All potentially unsafe characters are hex-escaped (\x<code>).

       -p, --paths
              Print full device paths.

       -r, --raw
              Produce  output  in  raw  format.  All potentially unsafe characters are hex-escaped (\x<code>) in the NAME, KNAME, LABEL, PARTLABEL and MOUNTPOINT
              columns.

       -S, --scsi
              Output info about SCSI devices only.  All partitions, slaves and holder devices are ignored.

       -s, --inverse
              Print dependencies in inverse order.

       -t, --topology
              Output info about block-device topology.  This option is equivalent to -o NAME,ALIGNMENT,MIN-IO,OPT-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,RQ-SIZE,WSAME.
\```

```bash
[root@centos7 ~]$lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  200G  0 disk 
├─sda1   8:1    0    1G  0 part /boot
├─sda2   8:2    0  100G  0 part /
├─sda3   8:3    0   50G  0 part /data
├─sda4   8:4    0    1K  0 part 
└─sda5   8:5    0    3G  0 part [SWAP]
sdb      8:16   0  100G  0 disk 
sr0     11:0    1 10.3G  0 rom  /run/media/steve/CentOS 7 x86_64
[root@centos7 ~]$lsblk --fs
NAME   FSTYPE  LABEL           UUID                                 MOUNTPOINT
sda                                                                 
├─sda1 xfs                     64e5c295-18f6-4a06-815c-96ce9f316b69 /boot
├─sda2 xfs                     2f98e043-cee1-4eaf-97f8-7ecf3cfd7228 /
├─sda3 xfs                     cae2d8fc-15b1-4750-bf94-267b411c4178 /data
├─sda4                                                              
└─sda5 swap                    eb86e30f-4567-4869-b840-1b70f6562bf9 [SWAP]
sdb                                                                 
sr0    iso9660 CentOS 7 x86_64 2019-09-09-19-08-41-00               /run/media/steve/CentOS 7 x86_64
[root@centos7 ~]$lsblk -f
NAME   FSTYPE  LABEL           UUID                                 MOUNTPOINT
sda                                                                 
├─sda1 xfs                     64e5c295-18f6-4a06-815c-96ce9f316b69 /boot
├─sda2 xfs                     2f98e043-cee1-4eaf-97f8-7ecf3cfd7228 /
├─sda3 xfs                     cae2d8fc-15b1-4750-bf94-267b411c4178 /data
├─sda4                                                              
└─sda5 swap                    eb86e30f-4567-4869-b840-1b70f6562bf9 [SWAP]
sdb                                                                 
sr0    iso9660 CentOS 7 x86_64 2019-09-09-19-08-41-00               /run/media/steve/CentOS 7 x86_64
[root@centos7 ~]$lsblk -t
NAME   ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED    RQ-SIZE   RA WSAME
sda            0    512      0     512     512    1 deadline     128 4096   32M
├─sda1         0    512      0     512     512    1 deadline     128 4096   32M
├─sda2         0    512      0     512     512    1 deadline     128 4096   32M
├─sda3         0    512      0     512     512    1 deadline     128 4096   32M
├─sda4         0    512      0     512     512    1 deadline     128 4096   32M
└─sda5         0    512      0     512     512    1 deadline     128 4096   32M
sdb            0    512      0     512     512    1 deadline     128 4096   32M
sr0            0   2048      0    2048    2048    1 deadline     128  128    0B
[root@centos7 ~]$lsblk -b
NAME   MAJ:MIN RM         SIZE RO TYPE MOUNTPOINT
sda      8:0    0 214748364800  0 disk 
├─sda1   8:1    0   1073741824  0 part /boot
├─sda2   8:2    0 107374182400  0 part /
├─sda3   8:3    0  53687091200  0 part /data
├─sda4   8:4    0         1024  0 part 
└─sda5   8:5    0   3221225472  0 part [SWAP]
sdb      8:16   0 107374182400  0 disk 
sr0     11:0    1  11026825216  0 rom  /run/media/steve/CentOS 7 x86_64
[root@centos7 ~]$lsblk -p /dev/sda
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
/dev/sda      8:0    0  200G  0 disk 
├─/dev/sda1   8:1    0    1G  0 part /boot
├─/dev/sda2   8:2    0  100G  0 part /
├─/dev/sda3   8:3    0   50G  0 part /data
├─/dev/sda4   8:4    0    1K  0 part 
└─/dev/sda5   8:5    0    3G  0 part [SWAP]
[root@centos7 ~]$lsblk -l /dev/sda
NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda    8:0    0  200G  0 disk 
sda1   8:1    0    1G  0 part /boot
sda2   8:2    0  100G  0 part /
sda3   8:3    0   50G  0 part /data
sda4   8:4    0    1K  0 part 
sda5   8:5    0    3G  0 part [SWAP]
```
> ## [mv] 移动或者重命名文件
- 用法：

```bash
       mv [OPTION]... [-T] SOURCE DEST
       mv [OPTION]... SOURCE... DIRECTORY
       mv [OPTION]... -t DIRECTORY SOURCE...
```
- 选项：
```bash
       --backup[=CONTROL]
              备份已经存在的目标文件，默认备份文件名为'原文件~'

       -b     类似 --backup 但是不接受参数

       -f, --force
              覆盖文件时不提示

       -i, --interactive
              覆盖前提示

       -n, --no-clobber
              不要覆盖已经存在的文件

       注意注意注意：如果多个选项被指定，最后一个有效

       --strip-trailing-slashes
              remove any trailing slashes from each SOURCE argument

       -S, --suffix=SUFFIX
              替换默认的备份文件名后缀

       -t, --target-directory=DIRECTORY
              move all SOURCE arguments into DIRECTORY

       -T, --no-target-directory
              视目标为普通文件

       -u, --update
              只有当源文件新于目标文件或者目标文件不存在时才移动
              
       -v, --verbose
              显示详细信息
```

> ## [nano] linux下的简单字符界面编辑器

> ## [runlevel] 显示系统运行级别
- 默认显示前一次和当前SysV系统运行级别
```bash
[root@centos7 /data]$runlevel
N 5
```
> 上面运行runlevel后显示N 5,中间为单个空格，N表示无法识别先前的系统运行级别，5表示目前系统运行与接5，即是带图形界面的级别。
> >  /var/run/utmp
           :runlevel 读取两个运行级别的utmp数据库所在的地方。

> ## [tty] 打印链接到标准输入的终端文件名

>  -s, --silent, --quiet
> > 不打印任何东西，只返回一个退出状态

```bash
[root@centos7 /data]$tty
/dev/pts/4
[root@centos7 /data]$tty -s
[root@centos7 /data]$echo $?  # 显示tty -s 的退出状态
0                             # 退出状态为0 表示成功执行
```

> ## [type] 判断某名称是否需要解析为命令名

> type -t name
> > -t选项表示type识别输入 的名称是否为别名、内置命令 、shell关键字或外部命令中的一种，若果都不是，则不打印任何信息，退出状态非0
```bash
[root@centos7 /data]$type -t ls
alias
[root@centos7 /data]$type -t ll
alias
[root@centos7 /data]$type -t cd
builtin
[root@centos7 /data]$type -t type
builtin
[root@centos7 /data]$type -t tr
file
[root@centos7 /data]$type -t /etc
[root@centos7 /data]$type -t /etc/fstab
[root@centos7 /data]$type -t if
keyword
[root@centos7 /data]$type -t esac
keyword
```

>  type标准输入 | 别名   |  内置命令   |   shell关键字  | 外部命令
> -------- | ----- |-----|-----|-----|
> type命令返回值 |  alias  |   builtin   |   keyword  | file   |

> ## [unalias] 从定义好的命令别名列表中移除某别名

```bash
> unalias [-a] [name ...]
```
> ualias -a 
> > 该命令会移除所有已经定义的命令别名

> ## [whoami] 打印有效的用户ID
- 默认打印当前系统的有效用户id所关联的用户名，同等于：id -un
```bash
[root@centos7 /var/www/html]$ whoami
root
[root@centos7 /var/www/html]$ who am i
root     pts/3        2019-09-21 13:53 (192.168.142.1)
[root@centos7 /var/www/html]$ who is 666
root     pts/3        2019-09-21 13:53 (192.168.142.1)
```

