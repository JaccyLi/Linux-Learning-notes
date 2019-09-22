@[TOC](linux网络配置之三-TCP报文)
OSI七层模型只是参考模型
#### 现实中使用的模型为TCP/IP模型
```bash
#TCP/IP五层模型
应用层：WEB服务器：http协议（应用层协议，访问不同页面）
传输层:封装端口
网络层:封装IP
数据链路：封装MAC
物理层：封装前导码
```
#### IP报文段含义
```bash
报文每行32bit长度，4个字节；
IP version：4bit版本号(V4/N6)
Hdr Len：4bit；首部长度，表示报文的行数，需要乘以4，才得到报文真正的长度
Type of Service：服务类型，8bits；标记该报文是否是加急传输等类型
Total length：16bits；标识报文长度，减去首部就是数据
Identification(Fragment ID)：16bits;报文被分片后使用Fragment ID标识，同一报文的片段Fragment ID必须相同
`不同的设备MTU（最大传输单元）不同，所以会将报文分片后传输`
Fragment Offset：13bits;标识报文片段的位置
MF(more fragment):标识该报文需要更多的片组合才是完整的报文
DF(dont fragment):标识该报文不能分片
TTL(Time-To-Live)：8bits；生存时间;经过的网关的个数（或经过的路由的次数）
Protocol:8bits；标识在data段中封装的上层协议类型；传输层的协议类型（TCP/UTP/SAMP）
Header Checksum:16bits；首部校验和
Source IP Address：32bits；源ip
Destination IP Address：32bits；目标ip
Options：可选段
Data：ip报文数据段
```
#### ip地址结构与划分
```bash
32位二进制
ipv4点分十进制：三个点隔开的四个段，每段取值0－255
0000 0000 － 1111 1111
0－255
如：221.23.24.12
网络地址
主机地址

为了能够标识不同规模的地址，ipv4地址被分类：
A类:第1段标识网络地址，后面3段标识主机地址（2^24个主机）
A类网络地址的子网掩码：255.0.0.0；8位
A类网络范围：
0 000 0001 － 0 111 1111 （1－127）
127个A类网络地址，127用于回环，有效1－126（2^7-1）
容纳主机个数：2^24－2
主机位为全0：网络地址
主机位为全1：广播地址

B类:前2段标识网络地址，后面2段标识主机地址（2^16个主机）
B类网络地址的子网掩码：255.255.0.0；16位
B类网络范围,第一段：
10 00 0001 － 10 11 1111 （128－191）
第一段有64个B类网络地址，后面8位随意变化，即总共有2^4*2^8=2^12个B类网络
容纳主机个数：2^16－2
主机位为全0：网络地址
主机位为全1：广播地址

C类：前3段标识网络地址，后面1段标识主机地址（2^8个主机）
C类网络地址的子网掩码：255.255.255.0；24位
C类网络范围,第一段：
110 0 0001 － 110 1 1111 （192－223）
第一段有32个C类网络地址，后面16位随意变化，即总共有2^5*2^16=2^21个C类网络
容纳主机个数：2^8－2
主机位为全0：网络地址
主机位为全1：广播地址

D类：
1110 0000 － 1110 1111（224－239）

E类：剩下的，240－255
```
**私有地址：地址分配机构事先预留的地址，谁都可以用，只能在本地使用**
```bash
A类：10.0.0.0/8(掩码长度为8):1个A类网
B类:172.16.0.0/16-172.31.0.0/16:16个B类网络
C类：192.168.0.0/24-192.168.255.0/24:256个C类网络
```
#### 路由表中路由条目（Entry）说明

主机路由：目标地址为主机地址
网络路由：目标地址为网络地址
选择时以最佳匹配作为选择标准
目标地址：0.0.0.0表示任意主机；默认路由，目标地址没有任何中间地址可以到达
路由汇聚：将小的子网合并为一个大网络
子网：大网络划分的小网络
超网：将小的子网合并为的一个大网络
如果某路由器在主干网，其连接的路由器会特别多；

#### TCP报文段含义
![TCP报文段含义](https://img-blog.csdnimg.cn/20190425230728995.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
```bash
Source Port Number:16bits;标识源端口地址
Destination Port Number:16bits;标识目标端口地址
Sequence Number:32bits;序列号
Acknowledgement Number:32bits;确认号
Header Length：4bits;同ip报文段
Reserved:6bits;保留位
URG(urgent):紧急位
ACK:确认位;为1,Acknowledgement Number有效;为0,Acknowledgement Number无效
PSH(push):推送,数据不在缓冲中存放，立即发出
RST:链接重置
SYN:
FIN:
Window Size：16bits，窗口大小
TCP Checksum：校验和
Urgent Pointer：16bits；紧急位为1有效
Options：选项
Data：数据
```

#### TCP建立通讯

![TCP建立通讯](https://img-blog.csdnimg.cn/20190425232547720.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)
建立链接：三次握手
第一步：A请求与B建立链接关系；SYN=1
第二步：B回应A;SYN=1,ACK=1
第三步：A回应B;ACK=1

断开链接：四次断开
第一步：A主动请求与B断开链接；FIN=1
第二步：B回应；ACK=1,FIN=1
第三步：B确认断开链接;ACK=1,FIN=1
第四步：断开链接;ACK=1,FIN=1

#### TCP/UDP的上层协议:应用层协议
http，pop，imap，dns，dhcp
这些应用层协议可能：
基于TCP，也可能基于UDP来完成端到端（进程之间）的通讯
利用IP完成主机到主机之间的通讯
利用底层协议（Ethernet，ppp，ATM）完成点到点通讯


对于linux而言，网络属于内核功能

