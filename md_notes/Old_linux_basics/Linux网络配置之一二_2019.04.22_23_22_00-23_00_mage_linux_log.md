@[TOC](Linux网络配置之一)
# 基础
协议：Protocol
**OSI七层模型**
```bash
应用层：WEB服务器：http协议（应用层协议，访问不同页面）
表示层：加密解密，压缩
会话层：建立会话
`传输层:封装端口
 网络层:封装IP`
数据链路：封装MAC
物理层：封装前导码
```
**ip报文**
```bash
Fragment ID：报文被分片后使用Fragment ID标识，同一报文的片段Fragment ID必须相同
Fragment Offset：标识报文片段的位置
MF(more fragment)
DF(dont fragment)
TTL(time-to-live)：生存时间
Protocol:传输层的协议类型（TCP/UTP/SAMP）
Header Checksum:首部校验和
Source IP Address：源ip
Destination IP Address：目标ip
Options：可选段
Data：ip报文数据段
```
**IP报文结构**
![ip报文结构](https://img-blog.csdnimg.cn/20190423223407655.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1lvdU9vcHM=,size_16,color_FFFFFF,t_70)

#### 总线型网络：
10Mbps网络：10M(2^20)个bit每秒 #2^20bit/s
MB:MByte
**Mbps/8=MB**
Ethernet：最早以太网是总线型网络
MAC:Media Access Control
 某台主机的唯一标识叫MAC地址
数据包包括：数据首部（报头）、数据、源地址、目标地址

广播：一对多
单播：一对一

CSMA/CD:Carrier Sense Multi Access Collision Detect载波监听多路访问冲突检测

#### 环型网络
使用令牌解决线路仲裁问题

#### 星型网络结构
使用HUB连接多个主机：实质是总线型结构网络

#### 网桥
冲突域：网桥引入是为了有效隔离冲突
[网桥工作原理](https://blog.csdn.net/mariofei/article/details/23298603)--[马里奥的专栏](https://blog.csdn.net/mariofei)
广播机制
网桥存储空间
学习机制
**多个端口的网桥就是交换机**
#### 交换机
交换机隔离冲突，不隔离广播

当交换机收到数据时，它会检查它的目的MAC地址，然后把数据从目的主机所在的接口转发出去。交换机之所以能实现这一功能，是因为交换机内部有一个MAC地址表，MAC地址表记录了网络中所有MAC地址与该交换机各端口的对应信息。某一数据帧需要转发时，交换机根据该数据帧的目的MAC地址来查找MAC地址表，从而得到该地址对应的端口，即知道具有该MAC地址的设备是连接在交换机的哪个端口上，然后交换机把数据帧从该端口转发出去。

[交换机的工作原理](https://blog.csdn.net/weixin_42048417/article/details/82386767)--[朝辞暮见](https://blog.csdn.net/weixin_42048417)

MAC表：自己学习填充也可以管理员填写


#### 逻辑地址/物理地址(MAC)
逻辑地址又叫：ip地址，用于标识不同的网络
```shell
逻辑地址被分为两段，一段标识网络地址，一段标识主机地址.
主机地址：标识本地网络不通的主机
网络地址：标识不同网络
```
**子网掩码**
```shell
子网掩码：根据逻辑地址取网络地址
0000 0001 . 0000 0001  #逻辑地址1.1
1111 1111 . 0000 0000  #子网掩码
0000 0001 . 0000 0000  #相与的结果就是网络地址1.0
1.0

假如1.1要与2.1通讯
1.1 --> 2.1
1.1和自己的掩码与一下得到1.0
1.1使用自己的掩码和目标地址与一下得到2.0
1.0与2.0不一样，表示2.0是不同的网络
此时数据通过网关转发
`本地主机的ip和网关一定要在同一网络中----常识`

假如1.1要与1.2通讯
1.1 --> 1.2
1.1和自己的掩码与一下得到1.0
1.1使用自己的掩码和目标地址与一下得到1.0
表示主机在同一网络
```

#### 路由器
```shell
路由器连接多个广播域
交换机连接多个冲突域
路由表：自动学习，利用协议来学习；
```

#### 端口标识进程之间的通讯
端口：使用端口来识别同一主机上的不同进程
每台主机端口号：0-65535 之间
web服务器端口：80
进程可以监听某个端口，进程和端口一一对应；
**ip和端口的绑定叫套接字：Socket（ip:port）**




网关：默认网关
**本地网络主机的通讯必须依靠MAC地址**
**交换机隔离冲突，不隔离广播**
本地通讯网络可以广播，不是本地通讯时，才向外部网络广播，使用逻辑地址标识主机地址。路由器来转发非本地通讯报文。
**本地首次通讯一定要广播，确定一个逻辑地址对应的MAC地址是什么。** 就是将逻辑地址转换为MAC地址的过程，这个过程称为地址解析，ARP(Address result protocol)。

#### 参考
[计算机网络第五版谢希仁答案](https://blog.csdn.net/zdx1996/article/details/72785968)--[周迪新](https://blog.csdn.net/zdx1996)


