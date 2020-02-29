<h1><font face="黑体" color="grey">Docker 网络管理(4)-容器跨主机通讯示例</font></h1>

容器夸主机互联就是将运行在不同的物理主机上的容器(不同的 docker 守护进程)
实现网络通讯。比如: A 宿主机的容器可以访问 B 主机上的容器，但是前提是保
证各宿主机之间的网络是可以相互通信的，然后各容器才可以通过宿主机访问到对
方的容器，实现原理是分别在两台宿主机做静态路由，复杂的网络或者大型的网络
可以使用 google 开源的 Kubernetes 进行互联。

# 修改 Docker 容器默认的网段

## server-node1

```bash
[root@docker-server-node1 ~]# ip addr show docker0
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:6a:44:06:58 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:6aff:fe44:658/64 scope link
       valid_lft forever preferred_lft forever

[root@docker-server-node1 ~]# vim /lib/systemd/system/docker.service
...
[Service]
Type=notify

# 增加--bip=10.100.0.1/24 选项
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --bip=bip=10.100.0.1/24
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
...

[root@docker-server-node1 ~]# systemctl daemon-reload
[root@docker-server-node1 ~]# systemctl restart docker.service
```

## 确认 server-node1 的 docker0 网卡网段

```bash
[root@docker-server-node1 ~]# ip addr show docker0
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:0a:95:c5:f4 brd ff:ff:ff:ff:ff:ff
    # 网段已经变为:10.100.0.1/24
    inet 10.100.0.1/24 brd 10.100.0.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:aff:fe95:c5f4/64 scope link
       valid_lft forever preferred_lft forever
```

## server-node2

```bash
[root@docker-server-node2 ~]# ip addr show docker0
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:6a:44:06:58 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:6aff:fe44:658/64 scope link
       valid_lft forever preferred_lft forever

[root@docker-server-node2 ~]# vim /lib/systemd/system/docker.service
......
[Service]
Type=notify

# 增加--bip=10.100.0.1/24 选项
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --bip=10.200.0.1/24
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
......

[root@docker-server-node2 ~]# systemctl daemon-reload
[root@docker-server-node2 ~]# systemctl restart docker
```

## 确认 server-node2 的 docker0 网卡网段

```bash
[root@docker-server-node2 ~]# ip addr show docker0
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 02:42:6a:44:06:58 brd ff:ff:ff:ff:ff:ff
    # 网段已经变为:10.200.0.1/24
    inet 10.200.0.1/24 brd 10.200.0.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:6aff:fe44:658/64 scope link
       valid_lft forever preferred_lft forever
```

# 两个主机分别启动容器

## server-node1 启动容器

```bash
[root@docker-server-node1 ~]# docker run -it -d -p 8080:8080 --name tomcat-node1 192.168.100.18:5000/stevenux/tomcat-business:app1
4767e80100b9e85a254b313eb5443493c72951a4cdd1a6bd608f3bf5e9133da7

[root@docker-server-node1 ~]# docker exec -it tomcat-node1 /bin/bash
[root@4767e80100b9 /]# ip addr show eth0
210: eth0@if211: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:64:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.100.0.2/24 brd 10.100.0.255 scope global eth0
       valid_lft forever preferred_lft forever

[root@4767e80100b9 /]# exit
exit
```

## server-node2 启动容器

```bash
[root@docker-server-node2 ~]# docker run -it -d -p 8080:8080 --name tomcat-node2 192.168.100.18:5000/stevenux/tomcat-business:app1
093da40d3987ae5d8df4b6e379754f8322127c504861e3b33b10753907b73730

[root@docker-server-node2 ~]# docker exec -it tomcat-node2  /bin/bash
[root@093da40d3987 /]# ip addr show eth0
173: eth0@if174: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:c8:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.200.0.2/24 brd 10.200.0.255 scope global eth0
       valid_lft forever preferred_lft forever

[root@093da40d3987 /]# exit
exit

```

# 添加静态路由

## 在 server-node1 上添加静态路由

```bash
[root@docker-server-node1 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.100.2   0.0.0.0         UG    100    0        0 eth0
10.100.0.0      0.0.0.0         255.255.255.0   U     0      0        0 docker0
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br-333954211ea9
192.168.100.0   0.0.0.0         255.255.255.0   U     100    0        0 eth0

# 添加到10.200.0.0/24网段的静态路由
[root@docker-server-node1 ~]# route add -net 10.200.0.0/24 gw 192.168.100.2
# 接收192.168.0.0/24网段发来的数据报文
[root@docker-server-node1 ~]# iptables -A FORWARD -s 192.168.0.0/24 -j ACCEPT
[root@docker-server-node1 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.100.2   0.0.0.0         UG    100    0        0 eth0
10.100.0.0      0.0.0.0         255.255.255.0   U     0      0        0 docker0
10.200.0.0      192.168.100.2   255.255.255.0   UG    0      0        0 eth0
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br-333954211ea9
192.168.100.0   0.0.0.0         255.255.255.0   U     100    0        0 eth0
```

#### ping server-node2 的容器 ip

```bash
[root@docker-server-node1 ~]# docker exec  -it tomcat-node1 /bin/bash
[root@4767e80100b9 /]# ping 10.200.0.2
PING 10.200.0.2 (10.200.0.2) 56(84) bytes of data.
64 bytes from 10.200.0.2: icmp_seq=1 ttl=62 time=0.271 ms
64 bytes from 10.200.0.2: icmp_seq=2 ttl=62 time=0.261 ms
64 bytes from 10.200.0.2: icmp_seq=3 ttl=62 time=0.293 ms
64 bytes from 10.200.0.2: icmp_seq=4 ttl=62 time=0.241 ms
64 bytes from 10.200.0.2: icmp_seq=5 ttl=62 time=0.334 ms
64 bytes from 10.200.0.2: icmp_seq=6 ttl=62 time=0.317 ms
64 bytes from 10.200.0.2: icmp_seq=7 ttl=62 time=0.311 ms
64 bytes from 10.200.0.2: icmp_seq=8 ttl=62 time=0.343 ms
64 bytes from 10.200.0.2: icmp_seq=9 ttl=62 time=0.335 ms
64 bytes from 10.200.0.2: icmp_seq=10 ttl=62 time=0.276 ms
64 bytes from 10.200.0.2: icmp_seq=11 ttl=62 time=0.395 ms
......

```

## 在 server-node2 上添加静态路由

```bash
[root@docker-server-node2 ~]# route add  -net 10.100.0.0/24 gw 192.168.100.10
[root@docker-server-node2 ~]#  iptables -A FORWARD -s 192.168.0.0/21 -j ACCEPT

[root@docker-server-node2 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.100.2   0.0.0.0         UG    100    0        0 eth0
10.100.0.0      192.168.100.10  255.255.255.0   UG    0      0        0 eth0
10.200.0.0      0.0.0.0         255.255.255.0   U     0      0        0 docker0
172.19.0.0      0.0.0.0         255.255.0.0     U     0      0        0 br-115abe13a9c0
192.168.100.0   0.0.0.0         255.255.255.0   U     100    0        0 eth0
```

#### ping server-node1 的容器 ip

```bash
[root@docker-server-node2 ~]# docker exec -it tomcat-node2  /bin/bash
[root@093da40d3987 /]# ping 10.100.0.2
PING 10.100.0.2 (10.100.0.2) 56(84) bytes of data.
64 bytes from 10.100.0.2: icmp_seq=1 ttl=62 time=0.515 ms
64 bytes from 10.100.0.2: icmp_seq=2 ttl=62 time=0.291 ms
64 bytes from 10.100.0.2: icmp_seq=3 ttl=62 time=0.353 ms
^C
--- 10.100.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.291/0.386/0.515/0.095 ms
[root@093da40d3987 /]# exit
exit

```

## 抓包分析

```bash
[root@docker-server-node2 ~]# docker exec -it tomcat-node2  /bin/bash
[root@093da40d3987 /]# ping 10.200.0.2
PING 10.200.0.2 (10.200.0.2) 56(84) bytes of data.
64 bytes from 10.100.0.2: icmp_seq=1 ttl=62 time=0.252 ms
64 bytes from 10.100.0.2: icmp_seq=2 ttl=62 time=0.216 ms
64 bytes from 10.100.0.2: icmp_seq=3 ttl=62 time=0.394 ms
64 bytes from 10.100.0.2: icmp_seq=4 ttl=62 time=0.269 ms
64 bytes from 10.100.0.2: icmp_seq=5 ttl=62 time=0.283 ms
64 bytes from 10.100.0.2: icmp_seq=6 ttl=62 time=0.297 ms
64 bytes from 10.100.0.2: icmp_seq=7 ttl=62 time=0.198 ms
64 bytes from 10.100.0.2: icmp_seq=8 ttl=62 time=0.232 ms
64 bytes from 10.100.0.2: icmp_seq=9 ttl=62 time=0.402 ms
64 bytes from 10.100.0.2: icmp_seq=10 ttl=62 time=0.372 m


[root@docker-server-node1 ~]# tcpdump  -i eth0 -vnn icmp
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
16:14:34.732821 IP (tos 0x0, ttl 63, id 22728, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.100.19 > 10.100.0.2: ICMP echo request, id 168, seq 8, length 64
16:14:34.732881 IP (tos 0x0, ttl 63, id 41403, offset 0, flags [none], proto ICMP (1), length 84)
    10.100.0.2 > 192.168.100.19: ICMP echo reply, id 168, seq 8, length 64
16:14:35.733133 IP (tos 0x0, ttl 63, id 22874, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.100.19 > 10.100.0.2: ICMP echo request, id 168, seq 9, length 64
16:14:35.733201 IP (tos 0x0, ttl 63, id 41513, offset 0, flags [none], proto ICMP (1), length 84)
    10.100.0.2 > 192.168.100.19: ICMP echo reply, id 168, seq 9, length 64
16:14:36.733410 IP (tos 0x0, ttl 63, id 23240, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.100.19 > 10.100.0.2: ICMP echo request, id 168, seq 10, length 64
16:14:36.733471 IP (tos 0x0, ttl 63, id 42328, offset 0, flags [none], proto ICMP (1), length 84)
    10.100.0.2 > 192.168.100.19: ICMP echo reply, id 168, seq 10, length 64

```

# 测试容器间互联

## server-node1 容 pings server-node2 容器

```bash
[root@docker-server-node1 ~]# docker exec  -it tomcat-node1 /bin/bash
[root@4767e80100b9 /]# ping 10.200.1.0
PING 10.200.1.0 (10.200.1.0) 56(84) bytes of data.
64 bytes from 10.300.0.2: icmp_seq=1 ttl=62 time=0.463 ms
64 bytes from 10.300.0.2: icmp_seq=2 ttl=62 time=0.385 ms
64 bytes from 10.300.0.2: icmp_seq=3 ttl=62 time=0.327 ms
^C
--- 10.100.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.235/0.306/0.633/0.136 ms
```

## server-node2 容器 ping server-node1 容器

```bash
[root@docker-server-node2 ~]# docker exec -it tomcat-node2  /bin/bash
[root@093da40d3987 /]# ping 10.100.0.2
PING 10.100.0.2 (10.100.0.2) 56(84) bytes of data.
64 bytes from 10.100.0.2: icmp_seq=1 ttl=62 time=0.583 ms
64 bytes from 10.100.0.2: icmp_seq=2 ttl=62 time=0.285 ms
64 bytes from 10.100.0.2: icmp_seq=3 ttl=62 time=0.347 ms
^C
--- 10.100.0.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.285/0.405/0.583/0.128 ms
```
