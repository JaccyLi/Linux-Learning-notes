
<center> <font face="黑体" size=7 color=grey>Linux磁盘管理和文件系统详细笔记</center>

<center><font face="黑体" size=4 color=grey> </center>

# 一.linux磁盘设备概述

- 在linux中一切皆为文件，设备也不例外；linux使用/dev/文件夹下的设备文件来与相关的设备建立联系，访问某个设备文件就是访问该设备。

```bash
比如：
    hexdump -C -512 /dev/sda1 
    该命令就访问了磁盘的第一个分区的前512个字节，即MBR分区；在linux中磁盘使用/dev/sda[b|c|d...] 设备文件来访问。

在操作系统的上层应用访问磁盘时，会通过系统调用来读写磁盘，如：
    open(), read(), write(), close() 
```

- linux设备类型包括: 

```bash
    块设备：block，存取单位“块”，磁盘 
    字符设备：char，存取单位“字符”，键盘 
```

- 设备文件：关联至一个设备驱动程序，进而能够跟与之对应硬件设备进行通信 

- 设备号码

```bash
    主设备号：major number, 标识设备类型 
    次设备号：minor number, 标识同一类型下的不同设备 
```

- linux磁盘设备命名

```bash
磁盘设备的设备文件命名：/dev/DEV_FILE 
SCSI, SATA, SAS, IDE,USB: /dev/sd 
某些云服务器虚拟磁盘：/dev/vd 、/dev/xvd 
不同磁盘标识：a-z,aa,ab… 
    /dev/sda, /dev/sdb, ... 
同一设备上的不同分区：1,2, ... 
    /dev/sda1, /dev/sda5 
硬盘存储术语 
    head：磁头 
    track：磁道 
    sector：扇区，512bytes 
    cylinder：柱面 
```
![](png/2019-10-14-20-52-01.png)

- 在linux中使用某磁盘需要经过以下几步:
  
```bash
1.设备识别,识别出的硬盘设备在/dev目录下
2.设备分区 
3.创建文件系统 
4.标记文件系统 
5.在/etc/fstab文件中创建条目 
6.挂载新的文件系统 
```

- 分区所带来的好处

```bash
1.优化I/O性能 
2.多个分区可以实现磁盘空间配额限制 
3.提高修复速度 
4.隔离系统和程序 
5.多个分区可以安装多个OS 
6.采用不同文件系统 
```

# 二.分区结构类型

- 目前主流的操作系统和相对应的硬件使用MBR和GPT分区方式之一，GPT分区格式比较新，所支持的容量更大，具备图形配置界面，所以大部分已经从传统的MBR分区格式转为使用GPT格式；而MBR分区格式需要配合传统的BIOS硬件；GPT则搭配较新的UEFI固件接口。

## 1.MBR

- MBR：Master Boot Record，1982年出现，使用32位表示扇区数，分区不超过2T 

```bash
MBR按柱面大小作为分区的基本容量单位；
MBR的元数据存放在0磁道0扇区：512bytes(整块硬盘的前512字节) 
前446bytes: boot loader 
紧接着的64bytes：分区表，其中每16bytes标识一个分区 
最后2bytes: 55AA (第511和512字节)
MBR分区中一块硬盘最多有4个主分区，也可以3主分区+1扩展(N个逻辑分区) 
```

## 2.MBR分区结构组织

![](png/2019-10-16-20-01-40.png)

```bash
硬盘主引导记录MBR由4个部分组成 
1.主引导程序（偏移地址0000H--0088H），它负责从活动分区中装载，并运行系统引导程序 
2.出错信息数据区，偏移地址0089H--00E1H为出错信息，00E2H--01BDH全为0字节 
3.分区表（DPT,Disk Partition Table）含4个分区项，偏移地址01BEH--01FDH, 每个分区表项长16个字节，共64字节为分区项1、分区项2、分区项3、分区项4 
4.结束标志字，偏移地址01FE--01FF的2个字节值为结束标志55AA 
```

- 各个区所对应的16位地址

![](png/2019-10-16-20-04-26.png)

- MBR主分区表中的分区表项具体含义
![](png/2019-10-16-20-06-56.png)

## 3.GPT分区 

```bash
1.GPT：GUID（Globals Unique Identifiers） partition table 支持128个分区使用64位，支持8Z（ 512Byte/block ）64Z （ 4096Byte/block） 
2.使用128位UUID(Universally Unique Identifier) 表示磁盘和分区 GPT分区表 自动备份在头和尾两份，并有CRC校验位 
3.UEFI (Unified Extensible Firmware Interface 统一可扩展固件接口)硬件支持 GPT，使操作系统启动
```

![](png/2019-10-16-20-10-04.png)

## 4.BIOS和UEFI 

```bash
1.BIOS是固化在电脑主板上一个程序，主要用于开机系统自检和引导操作系统。 目前新式的电脑基本上都是UEFI启动 
2.BIOS（Basic Input Output System 基本输入输出系统）对于普通用户来说，主要完成系统硬件自检和引导操作系统，
操作系统开始启动之后，BIOS的任务就完成了。系统硬件自检：如果系统硬件有故障，主板上的扬声器就会发出长短不同的“滴滴”音，
可以简单的判断硬件故障，比如“1长1短”通常表示内存故障，“1长3短”通常表示显卡故障  
3.BIOS在1975年就诞生了，使用汇编语言编写，当初只有16位，因此只能访问 1M的内存，其中前640K称为基本内存，
后384K内存留给开机和各类BIOS本身 使用。BIOS只能识别到主引导记录（MBR）初始化的硬盘，最大支持2T的硬盘，4个主分区（逻辑分区中的扩展分区除外），而目前普遍实现了64位系统，传统
的BIOS已经无法满足需求了，这时英特尔主导的EFI就诞生了
```

## 5.BIOS+MBR与UEFI+GPT 

![](png/2019-10-16-20-27-43.png)

# 三.分区管理

## 1.查看磁盘设备和分区信息

### lsblk 
 
## 2.创建分区

### fdisk 创建MBR分区 | gdisk 创建GPT分区 

```bash
gdisk /dev/sdb 类fdisk 的GPT分区工具 
fdisk -l [-u] [device...] 查看分区 
fdisk /dev/sdb  管理分区 
子命令： 
p  分区列表 
t  更改分区类型 
n  创建新分区 
d  删除分区 
v  校验分区 
u  转换单位 
w  保存并退出 
q  不保存并退出 
``` 
 
### parted 高级分区操作 

```bash
注意：parted的操作都是实时生效的，小心使用 
用法：parted [选项]... [设备 [命令 [参数]...]...]  
    parted /dev/sdb  mklabel gpt|msdos 
    parted /dev/sdb  print 
    parted /dev/sdb  mkpart primary 1 200 （默认M） 
    parted /dev/sdb  rm 1 
    parted –l   列出分区信息 
```

### 分区完成后使用partprobe更新分区信息

## 3.同步分区表 

```bash
查看内核是否已经识别新的分区 
    cat /proc/partations 
centos6通知内核重新读取硬盘分区表 
    新增分区用  
        partx -a  /dev/DEVICE 
        kpartx -a /dev/DEVICE -f: force 
    删除分区用 
        partx -d --nr M-N /dev/DEVICE 
CentOS 5，7: 使用partprobe 
    qpartprobe [/dev/DEVICE] 
```

# 四.管理文件系统 

## 1.文件系统 

- 文件系统是操作系统用于明确存储设备或分区上的文件的方法和数据结构；即
在存储设备上组织文件的方法。操作系统中负责管理和存储文件信息的软件结
构称为文件管理系统，简称文件系统 
- 从系统角度来看，文件系统是对文件存储设备的空间进行组织和分配，负责文
件存储并对存入的文件进行保护和检索的系统。具体地说，它负责为用户建立
文件，存入、读出、修改、转储文件，控制文件的存取，安全控制，日志，压
缩，加密等 
- 查看linux支持的文件系统：/lib/modules/ùname –r`/kernel/fs 
- [wikipedia所罗列的各种文件系统](https://en.wikipedia.org/wiki/Comparison_of_file_systems)
- 帮助：man 5 fs 

## 2.文件系统类型 

```bash
Linux文件系统：  
    1.ext2(Extended file system)：适用于那些分区容量不是太大，更新也不频繁的情况，
        例如 /boot 分区 
    2.ext3：是 ext2 的改进版本，其支持日志功能，能够帮助系统从非正常关机导致的异常
    中恢复。它通常被用作通用的文件系统 
    3.ext4：是 ext 文件系统的最新版。提供了很多新的特性，包括纳秒级时间戳、创建和
    使用巨型文件(16TB)、最大1EB的文件系统，以及速度的提升 
    4.xfs：SGI，支持最大8EB的文件系统 
    5.btrfs（Oracle）, reiserfs, jfs（AIX）, swap 
    6.光盘：iso9660 
7.Windows：FAT32, NTFS，exFAT 
8.Unix：FFS（fast）, UFS（unix）, JFS2 
9.网络文件系统：NFS, CIFS 
10.集群文件系统：GFS2, OCFS2（oracle） 
11.分布式文件系统：fastdfs,ceph, moosefs, mogilefs, glusterfs, Lustre 
12.RAW：未经处理或者未经格式化产生的文件系统
```

## 3.linux文件系统分类 

```bash
根据其是否支持"journal"功能分： 
    日志型文件系统: ext3, ext4, xfs, ... 
    非日志型文件系统: ext2, vfat 
文件系统的组成部分： 
    内核中的模块：ext4, xfs, vfat 
    用户空间的管理工具：mkfs.ext4, mkfs.xfs,mkfs.vfat 
Linux的虚拟文件系统：VFS 
查前支持的文件系统：cat /proc/filesystems 
```

## 4.linux的VFX

![](png/2019-10-16-20-52-13.png)

## 5.linux文件系统的选择

```bash
文件系统选择 
1.EXT3 
    最多只能支持32TB的文件系统和2TB的文件，实际只能容纳2TB的文件系统和16GB的文件 
    Ext3目前只支持32000个子目录 
    Ext3文件系统使用32位空间记录块数量和 inode数量 
    当数据写入到Ext3文件系统中时，Ext3的数据块分配器每次只能分配一个4KB的块 
2.EXT4：EXT4是Linux系统下的日志文件系统，是EXT3文件系统的后继版本 
    Ext4的文件系统容量达到1EB，而文件容量则达到16TB 
    理论上支持无限数量的子目录 
    Ext4文件系统使用64位空间记录块数量和 inode数量 
    Ext4的多块分配器支持一次调用分配多个数据块 
    修复速度更快 
3.XFS 
    根据所记录的日志在很短的时间内迅速恢复磁盘文件内容 
    采用优化算法，日志记录对整体文件操作影响非常小 
    是一个全64-bit的文件系统，最大可以支持8EB的文件系统 
    能以接近裸设备I/O的性能存储数据 
```

# 五.挂载/卸载设备 

# 六.管理虚拟内存 

# 七.RAID管理 

# 八.LVM管理 

# 九.LVM快照 