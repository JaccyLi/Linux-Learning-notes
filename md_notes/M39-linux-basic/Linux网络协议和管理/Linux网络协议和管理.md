<center> <font face="黑体" size=7 color=grey>Linux网络协议和管理</center>

<center><font face="黑体" size=4 color=grey> </center>



# 一.网络设备基本知识 

![](png/网络设备基本知识.png)

# 二.TCP/IP协议栈简介 

## 1.概述

![](png/TCP-IP协议栈.png)

## 2.数据链路层

- 在TCP/IP协议族中，链路层主要有三个目的

```bash
（1）为IP模块发送和接收IP数据报；
（2）为ARP模块发送ARP请求和接收ARP应答；
（3）为RARP发送RARP请求和接收RARP应答。
```

- TCP/IP支持多种不同的链路层协议，这取决于网络所使用的硬件，
&emsp;&emsp;如以 太网、令牌环网、FDDI（光纤分布式数据接口）及RS-232串行线路等。

- IEEE802.2-802.3和以太网的数据帧封装格式
![](visio/IEEE802.2-802.3和以太网的封装格式.svg)

- PPP数据帧的格式
![](visio/PPP数据帧的格式.svg)

## 3.网络层

- IP报文头部格式

- ICMP

- IGMP
 
## 4.传输层

- TCP头部格式

- UDP头部格式


# 五.IP地址规划 

## 1.传统的IP地址分类

## 2.CIDR表示的网络地址

## 3.子网的划分

## 4.路由的概念

# 六.Linux网络配置详解 

## 1.Linux网络管理命令及配置文件概览

### 命令概览

```bash
ifconfig
route
netstat
ip: object {link, addr, route}
ss
tc  
system-config-network-tui
setup
nmcli
nm-connection-editor
```

### 配置文件概览

## 2.命令详细介绍



# 七.多网卡绑定技术 

## 1.概念

## 2.实现


# 八.Linux软件网桥

## 1.概念

## 2.实现


# 九.Linux下的网络测试工具

## hostname显示主机名 

hostname 

## ping测试网络连通性 

ping  

## ip/route显示正确的路由表 

ip route 

## 跟踪路由 

traceroute 
tracepath 
mtr 

## 确定名称服务器

nslookup 
host 
dig 