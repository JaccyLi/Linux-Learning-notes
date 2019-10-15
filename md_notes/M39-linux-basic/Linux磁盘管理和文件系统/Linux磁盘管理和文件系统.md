
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



# 二.分区结构类型




# 三.分区管理


# 四.管理文件系统 

# 五.挂载/卸载设备 

# 六.管理虚拟内存 

# 七.RAID管理 

# 八.LVM管理 

# 九.LVM快照 