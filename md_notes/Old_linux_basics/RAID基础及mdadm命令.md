@[TOC](RAID基础及mdadm命令)

![RAID基础及mdadm命令](https://img-blog.csdnimg.cn/2019041023042366.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
现在RAID组合一般使用：SATA或者SAS（73GB,146GB）转速快所以容量小；
集成在主板叫：Controller
独立的叫：Adaptor

SCSI接口分为：窄带接口和宽带接口
窄带：8个接口，包括1个Initiator（Controller），7个target（接外部硬盘）；
宽带：16个接口，包括1个Initiator（Controller），15个target（接外部硬盘）；
扩展：
将每个target分为n个子接口：每个子接口又可以接一块硬盘

## RAID的实现
### 硬件实现RAID
一般公司使用硬件RAID，服务器上一般直接集成RAID控制器；
![硬件实现RAID示意图](https://img-blog.csdnimg.cn/20190411123636540.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
绿色为主板；主板集成了RAID控制器，则需要在BIOS设置；BIOS配置好后，系统看到的不是硬盘而是RAID0,RAID1等；
安装操作系统必须要识别RAID控制器，安装驱动程序
RAID0被系统识别为：/dev/sda
RAID1被系统识别为：/dev/sdb
并不识别某块硬盘
某些主板上的RAID控制器自带电池，由于RAID控制器本身有自己的内存，为防止控制器将缓存在其内存中的数据往硬盘存储时断电，所以有自带电池；


### 软件实现RAID
主板上只有SATA硬盘，一块装数据，其他存数据；
#### Multi Disks
内核中有个模块叫md：Multi Disks
现在除操作系统所在盘外有额外4块硬盘：
内核中md模块模拟一个RAID设备，称为模拟设备：/dev/md#
如：/dev/md0,/dev/md1,...
有某个程序将数据分成片存到各个磁盘；用户看到的是RAID设备，内核看到的还是多块硬盘。
**一般不建议生产环境使用软件模拟RAID**

#### mdadm将任何块设备做成RAID
mdadm：允许将任何块设备做成RAID

mdadm如何工作的？
```
模式化命令：
	创建模式 ：-C （Create）
		专用选项：   -l:指定级别
							 -n #:指定设备个数
							 -a {yes|no}：自动为其创建设备文件
							 -c：指定CHUNK数据块大小,2^nK，默认为64K
							 -x #：指定空闲盘个数
	eg：mdadm -C /dev/md0 -a yes -l 0 -n 2 /dev/sda{5,6}
	#使用/dev/sda5,/dev/sda5两个设备（分区）创建级别0的RAID
	管理模式 ：--add，--del，{-r|--remove}，--fail
		mdadm /dev/md# --fail /dev/sda7    #模拟设备/dev/sda7损坏，详细信息中显示坏，实际可用 
	监控模式 ：-F （Follow） 
	增长模式 ：-G   (Grow)
	装配模式 ：-A （Assemble）
	显示RAID阵列设备详细信息：mdadm {-D|--detail} /dev/md#
	cat /proc/mdstat
	停止阵列：
		mdadm {-S|--stop} /dev/md#
	将当期RAID信息保存至文件：
		mdadm -D --scan > /etc/mdadm.conf				
```
在格式化RAID时：mke2fs -j -E strip=16 -b 4096 /dev/md2
-E strip=# :指定条带大小，（CHUNK数据块大小,2^nK，默认为64K），
此处指定为16，4k*16=64k，有利于提供RAID性能

#### 练习
```bash   
软件模拟一个2G的RAID0:
	2G:
		4:512MB
		2:1GB
mdadm -C /dev/md0 -a yes -l 0 -n 2 /dev/sda{5,6}
mke2fs -j /dev/md0
mount /dev/md0 mnt

软件模拟一个2G的RAID1:
	2G:
		2:2G
mdadm -C /dev/md1 -a yes -l 0 -n 2 /dev/sda{7,8}
mke2fs -j /dev/md1
mount /dev/md1 mnt

软件模拟一个2G的RAID5:
	2G:
		3:1G
mdadm -C /dev/md2 -a yes -l 3 -n 3 /dev/sda{9,10,11}
mke2fs -j /dev/md2
mount /dev/md2 mnt
```

## watch命令周期性执行指定命令
watch命令周期性执行指定命令，并以全屏形式输出结果
-n #：指定周期长度，单位为秒，默认为2
格式：
```bash
 watch -n 2 `COMMAND`  #每两秒执行一次COMMAND
```
## lsmod命令列出内核模块状态
## dm ：Device Mapper
功能比md功能强大，不止可以实现RAID;
md做RAID;dm做LVM2

dm：LVM2
	linear：
	mirror：类似RAID镜像
	snapshot：快照，保留某一刻数据
		主要作用：数据备份
	multipath：
	逻辑设备：动态增减文件系统空间
	![dm功能](https://img-blog.csdnimg.cn/20190412225130283.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
```1	
		PV:Physical Volume
		VG:Volume Group
		PE：Physical Extend
		LV:Logical Volume
		LE:Logical Extend
```
```shell
查看：pvs，vgs，lvs
	管理物理卷:pv
		pvcreate,pvremove,pvscan,pvdisply,pvmove
		eg:pvcreate /dev/sda{10,11}  #/dev/sda{10,11}的分区类型需要调整为8e（Linux LVM）
	管理卷组:vg
		vgcreate,vgremove,vgrename,vgscan,vgdisply,vgmove，vgextend，vgreduce
		vgcreate VG_NAME /PATH/TO/PV
			-s #:指定PE大小，默认为4MB
		eg:vgcreate myvg /dev/sda{10,11}  #使用/dev/sda{10,11}两个卷创建名为myvg的卷组
		eg:vgreduce myvg /dev/sda11  #从myvg中缩减/dev/sda11
		   vgremove myvg /dev/sda11   #从myvg中删除/dev/sda11
		vgextend myvg /dev/sda12  ##myvg扩容，扩容大小/dev/sda12
	管理逻辑卷:lv
		lvcreate，
		lvcreate -n LV_NAME -L #G VGNAME
		-n 指定名称
		-L 指定空间大小（#G|#M|#K）
		VGNAME:指定在哪个VG中创建
```		
	 
