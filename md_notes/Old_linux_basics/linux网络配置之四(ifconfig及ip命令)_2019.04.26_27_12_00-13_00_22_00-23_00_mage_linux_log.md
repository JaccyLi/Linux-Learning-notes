@[TOC](ifconfig及ip命令)
#### 主机接入网络需要配置的内容
IP:
NETMASK:
GATEWAY:
HOSTNAME:
DNS(NDS服务器地址):
```bash
linux配置三个NDS服务器地址
DNS1
DNS2
DNS3
一般第一个服务器地址解析不到，第二个也解析不到；配置三个是防止某个服务器不在线或者解析慢。
```
路由:
DHCP动态获取
Dynamic Host Configuration Protocol
如果无法动态获取地址（没有DHCP服务器），可以使用预留的ip进行本地通讯，但是无法接入外部网络；预留的以169.254.开头，自动获得某个随机地址，没有掩码。


Linux：网络属于内核功能
配置时看上去地址属于网卡，实质上地址属于内核；外部ping有多个网卡的本地主机时，通过某一网卡后，无论其他网卡的ip是多少，都可以ping通

linux如何识别网络接口
对于linux而言，每个网络接口都有一个名称
lo:本地回环接口
以太网网卡：ethX（X：数字）
点对点连接：pppX（X：数字）

#### ifconfig
```bash
ifconfig [ethX]
	-a:显示所有接口的配置
	
配置：
ifconfig ethX IP/MASK  #配置ip地址，子网掩码位数必须指定
eg: ifconfig eth0 10.1.1.2/8  #配置eth0接口的ip地址，并且指定掩码为8位

禁用：down
启用：up
ifconfig ethX {down|up}
ifconfig eth0 down
ifconfig eth0 up
配置立即生效，但是不会永久生效；`重启网络服务或主机都会失效`自己ping自己可以检测内核的网络协议栈是否正常工作
网络服务脚本：
RHEL5:/etc/init.d/network {start|stop|restart|status}
RHEL6:/etc/init.d/NetworkManager {start|stop|restart|status}

```
#### 配置网关route
```bash
route
	add:添加
		-host:主机路由
		-net:网络路由
			-net 0.0.0.0
        route add -net|-host DEST gw NEXTHOP
        route add default gw NEXTHOP #添加默认路由
	eg: route add -net 10.0.0.0/8 gw 192.168.10.1
		#表示10.0.0.0可以通过192.168.10.1到达
	del:删除
		-host
		-net
		eg:
		route del -net 10.0.0.0/8
		route del -net 10.0.0.0
		route del default
	以上所作出的改动重启网络服务或者主机后失效；
查看：
	route -n:以数字方式显示各主机名或端口等相关信息

route add default gw 192.68.10.1
#表示到达任意主机default（0.0.0.0）都可以经过192.68.10.1	
`重启网络服务或主机都会失效`	
```

#### 网络配置相关文件
```bash
网络配置文件:
/etc/sysconfig/network


网络接口配置文件：
/etc/sysconfig/network-scripts/ifcfg-INTERFACE_NAME
DEVICE=:关联的设备名称，要与文件名的后半部“INTERFACE_NAME”保持一致；
BOOTPROTO={static|none|dhcp|bootp}:引导协议；要使用静态地址，使用static或none；dhcp表示使用DHCP服务器获取地址；
IPADDR=:IP地址
NETMASK=:子网掩码
GATEWAY=:设定默认网关
ONBOOT=:开机时是否自动激活此网络接口
HWADDR=:硬件地址，要与硬件中的地址保持一致，可省
USERCTL={yes|no}:表示是否允许普通用户控制此接口
PEERDNS={yes|no}:是否在BOOTPROTO为dhcp时接受有DHCP服务器指定的DNS地址
`通过这种方式配置不会立即生效，但重启网络服务或主机后生效,并且永久有效；`

路由的配置：如果没有创建该文件
/etc/sysconfig/network-scripts/rout-ethX
添加格式一：
DEST0	via		NEXTHOP0
DEST2	via		NEXTHOP2
DEST3	via		NEXTHOP3
...

添加格式二：
ADDRESS0=
NETMASK0=
GATEWAY0=
...
ADDRESS6=
NETMASK6=
GATEWAY6=
...
```
#### DNS服务器配置只能修该配置文件
```bash
/etc/resolve.conf
#edit this file
nameaerver NDS_IP_1
nameaerver NDS_IP_2
nameaerver NDS_IP_3
```
**指定本地解析DNS**
/etc/hosts
```bash
#字段意义
主机ip		主机名		主机别名
本机会首先查看/etc/hosts文件有没有相应的条目
DNS解析顺序:DNS-->/etc/hosts-->DNS

配置主机名：
hostname HOSTNAME   #立即生效不永久生效
/etc/sysconfig/network   #永久生效不立即生效
HOSTNAME=
```
#### ip命令
iproute2软件包提供了ip命令
```bash
ip
	link:配置网络接口属性
		show：查看所有网络接口信息
		eg:ip -s link show 显示详细信息
		set:设置
		ip link set DEVICE {up|down}
		
	addr:协议地址
		add：增加地址，某网卡的辅助地址，不是第二个地址
		ip addr add ADDRESS dev DEV
		eg：ip addr add 192.158.32.123/24 dev enp0s3  #将地址192.158.32.123指定给设备enp0s3，作为其辅助地址
		eg：ip addr add 192.158.32.123/24 dev enp0s3 label enp0s3:3 #enp0s3:3为enp0s3的别名

		del：删除地址
		ip addr del ADDRESS dev DEV
		show：显示接口设备地址
		ip addr show dev DEV to PREFIX #显示以PREFIX开头的地址
		flush：同del：删除地址
		ip addr flush dev DEV to PREFIX
	一块网卡可以使用多个地址
	网络设备ethX的别名：
	ethX:X
	eg：eth0的别名可以是：eth0:0,eth0:1,...
	配置别名方法：
	法一：ifconfig ethX:X IP/NETMASK
	法二：/etc/sysconfig/network-scripts/ifcfg-ethX:X
		 DEVICE=ethX:X
	
	route:路由
	待续...

```

