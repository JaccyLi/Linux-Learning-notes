<h1><font face="黑体" color="grey">Docker 网络管理(5)-自定义网络</font></h1>

Docker 的自定义网络可以自定义 IP 地范围和网关等信息，实质是穿件一个可以
自定义的桥接网络给容器使用。其与默认的桥接网络有如下区别:

1. **用户创建的桥接网络提供容器间自动 DNS 解析**
   在默认的桥接网络中的容器互相之间只能通过 IP 地址访问对方(使用`--link`
   连接的容器除外)。在用户自定义的网络中，容器则可以使用容器名或容器别名
   来解析对方。

2. **用户创建的桥接网络提供更好的隔离**
   使用用户创建的桥接网络提供了具有作用域的网络(scoped network)，只允许
   加入到该网络的容器间互相通讯。而在创建容器时不指定网络的话就加入到默认
   的桥接网络，这样不同业务或者不同技术栈的容器就能相互通讯，而生产中一般
   是不允许这样的。

3. **容器可以接入(attach)或者断开(detach)用户自定义的桥接网络并即时生效**
   在某容器的生命周期任意时刻，可以即时连接到用户定义的网络或从其断开。如果
   要将容器从默认的桥接网络断开则需要停止容器，并使用不同的网络选项配置启动
   新的容器。

4. **每个用户自定义的网络都会新建一个可配置的网桥**
   如果容器使用的默认桥接网络，则所有容器使用相同的配置设定(如:MTU 和 iptables
   规则等。)。更改默认的桥接网络配置需要重启 docker。用户创建的桥接网络使用
   `docker network create`命令创建。如果不同的应用组需要不同的网络配置，则
   可以更改每个组对应的用户自定义桥接网络。

5. **使用 `--link` 选项连接的容器在默认网络中共享环境变量**
   最初，在两个容器之间共享环境变量的唯一方法只能使用`--link`选项实现。这种
   共享环境变量的方式在用户自定义的桥接网络中是不可以使用的。但是，可以使用
   其它更高级的方式来共享环境变量。如：
   1. 多个容器之间可以通过 docker 的数据卷挂载包含共享信息的文件或者目录。
   2. 多个容器可以使用`docker-compose`工具启动，compose 文件(.yaml/.yml)
      可以定义共享的变量。
   3. 使用 swarm service

连接到相同的用户自定义桥接网络的容器会互相暴露端口。如果需要外部网络访问
容器，则必须使用`-p`或`--publish`选项映射端口。

# 一. 创建自定义桥接网络

```bash
[root@docker-server-node1 ~]# docker network create -d bridge --subnet 10.200.0.0/24 --gateway 10.200.0.1 cus-net
1bdac1e7b929e2aa46d030e067fc469b119d74298ab815d46927a2046cb58dcd
[root@docker-server-node1 ~]# docker network list
NETWORK ID          NAME                DRIVER              SCOPE
dfe6872f18a8        bridge              bridge              local
1bdac1e7b929        cus-net             bridge              local
333954211ea9        harbor_harbor       bridge              local
a36a7fe27d63        host                host                local
23e18d8a54e0        none                null                local
```

# 二. 启动两个使用自定义网络的容器并通讯测试

## 2.1 启动容器

```bash
[root@docker-server-node1 ~]# docker run -it -d --name nginx-node1-use-cus-net --net=cus-net nginx:compiled_V1
0ac566096fe9674732ac29cf81e49308813368b58bb0140a42df35f86c337804
[root@docker-server-node1 ~]# docker run -it -d --name nginx-node2-use-cus-net --net=cus-net nginx:compiled_V1
df5816c94fe0637e05b2a5d0722078ae7ef132018f8d7b3b67a4af716b88f213
[root@docker-server-node1 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
df5816c94fe0        nginx:compiled_V1   "nginx -g 'daemon of…"   4 seconds ago       Up 4 seconds        80/tcp, 443/tcp     nginx-node2-use-cus-net
0ac566096fe9        nginx:compiled_V1   "nginx -g 'daemon of…"   16 seconds ago      Up 15 seconds       80/tcp, 443/tcp     nginx-node1-use-cus-net
```

## 2.2 分别在两个容器 ping 对方

### 2.2.1 node1 ping node2

```bash
[root@docker-server-node1 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
df5816c94fe0        nginx:compiled_V1   "nginx -g 'daemon of…"   About a minute ago   Up About a minute   80/tcp, 443/tcp     nginx-node2-use-cus-net
0ac566096fe9        nginx:compiled_V1   "nginx -g 'daemon of…"   About a minute ago   Up About a minute   80/tcp, 443/tcp     nginx-node1-use-cus-net
[root@docker-server-node1 ~]# docker exec -it nginx-node1-use-cus-net  /bin/bash
[root@0ac566096fe9 /]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
213: eth0@if214: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:c8:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.200.0.2/24 brd 10.200.0.255 scope global eth0
       valid_lft forever preferred_lft forever
[root@0ac566096fe9 /]# ping 10.200.0.3
PING 10.200.0.3 (10.200.0.3) 56(84) bytes of data.
64 bytes from 10.200.0.3: icmp_seq=1 ttl=64 time=0.129 ms
64 bytes from 10.200.0.3: icmp_seq=2 ttl=64 time=0.039 ms
^C
--- 10.200.0.3 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.039/0.084/0.129/0.045 ms
[root@0ac566096fe9 /]# env
HOSTNAME=0ac566096fe9
TERM=xterm
LS_COLORS=...
password=stevenux
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
SHLVL=1
HOME=/root
_=/usr/bin/env
[root@0ac566096fe9 /]# ping nginx-node2-use-cus-net      # 在用户自定义的网络中默认使用容器名照样可以通讯
PING nginx-node2-use-cus-net (10.200.0.3) 56(84) bytes of data.
64 bytes from nginx-node2-use-cus-net.cus-net (10.200.0.3): icmp_seq=1 ttl=64 time=0.043 ms
64 bytes from nginx-node2-use-cus-net.cus-net (10.200.0.3): icmp_seq=2 ttl=64 time=0.074 ms
^C
--- nginx-node2-use-cus-net ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 0.043/0.058/0.074/0.017 ms
[root@0ac566096fe9 /]# exit
exit
```

### 2.2.2 node2 ping node1

```bash
[root@docker-server-node1 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
df5816c94fe0        nginx:compiled_V1   "nginx -g 'daemon of…"   About a minute ago   Up About a minute   80/tcp, 443/tcp     nginx-node2-use-cus-net
0ac566096fe9        nginx:compiled_V1   "nginx -g 'daemon of…"   About a minute ago   Up About a minute   80/tcp, 443/tcp     nginx-node1-use-cus-net
[root@docker-server-node1 ~]# docker exec -it nginx-node2-use-cus-net  /bin/bash
[root@df5816c94fe0 /]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
215: eth0@if216: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:c8:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.200.0.3/24 brd 10.200.0.255 scope global eth0
       valid_lft forever preferred_lft forever
[root@df5816c94fe0 /]# ping 10.200.0.2
PING 10.200.0.2 (10.200.0.2) 56(84) bytes of data.
64 bytes from 10.200.0.2: icmp_seq=1 ttl=64 time=0.034 ms
64 bytes from 10.200.0.2: icmp_seq=2 ttl=64 time=0.039 ms
^C
--- 10.200.0.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.034/0.036/0.039/0.006 ms
[root@df5816c94fe0 /]# env
HOSTNAME=df5816c94fe0
TERM=xterm
LS_COLORS=......
password=stevenux
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
SHLVL=1
HOME=/root
_=/usr/bin/env
[root@df5816c94fe0 /]# ping nginx-node1-use-cus-net  # 在用户自定义的网络中默认使用容器名照样可以通讯
PING nginx-node1-use-cus-net (10.200.0.2) 56(84) bytes of data.
64 bytes from nginx-node1-use-cus-net.cus-net (10.200.0.2): icmp_seq=1 ttl=64 time=0.101 ms
64 bytes from nginx-node1-use-cus-net.cus-net (10.200.0.2): icmp_seq=2 ttl=64 time=0.038 ms
^C
--- nginx-node1-use-cus-net ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.038/0.069/0.101/0.032 ms
[root@df5816c94fe0 /]# exit
exit

```

## 2.3 分析 node1 和 node2 的容器通讯实质

server-node1(192.168.100.10)的容器地址为 10.100.0.2
server-node2(192.168.100.19)的容器地址为 10.200.0.2

1. 查看两台机子状态

```bash
# 主机server-node1路由表及容器IP
[root@docker-server-node1 ~]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.100.0.0      0.0.0.0         255.255.255.0   U     0      0        0 docker0
10.200.0.0      192.168.100.19  255.255.255.0   UG    0      0        0 eth0
10.200.0.0      0.0.0.0         255.255.255.0   U     0      0        0 br-1bdac1e7b929
......

[root@b41090f73ff0 /]# ip addr show eth0
217: eth0@if218: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:0a:64:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.100.0.2/24 brd 10.100.0.255 scope global eth0
       valid_lft forever preferred_lft forever


# 主机server-node2路由表及容器IP


```

2. 从 server-node2(192.168.100.19，容器 IP:10.200.0.2)的容器 ping
   server-node1(192.168.100.10，容器 IP:10.100.0.2)，并在 server-node2
   上抓包分析:

```bash
[root@docker-server-node2 ~]# docker exec -it tomcat-node2 /bin/bash
[root@093da40d3987 /]# ping 10.100.0.2
PING 10.100.0.2 (10.100.0.2) 56(84) bytes of data.
64 bytes from 10.100.0.2: icmp_seq=1 ttl=62 time=0.324 ms
64 bytes from 10.100.0.2: icmp_seq=2 ttl=62 time=0.381 ms
64 bytes from 10.100.0.2: icmp_seq=3 ttl=62 time=0.368 ms
64 bytes from 10.100.0.2: icmp_seq=4 ttl=62 time=0.356 ms
64 bytes from 10.100.0.2: icmp_seq=5 ttl=62 time=0.430 ms
64 bytes from 10.100.0.2: icmp_seq=6 ttl=62 time=0.358 ms
64 bytes from 10.100.0.2: icmp_seq=7 ttl=62 time=0.369 ms
64 bytes from 10.100.0.2: icmp_seq=8 ttl=62 time=2.46 ms
64 bytes from 10.100.0.2: icmp_seq=9 ttl=62 time=0.393 ms
64 bytes from 10.100.0.2: icmp_seq=10 ttl=62 time=2.16 ms
^C
--- 10.100.0.2 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 20024ms
rtt min/avg/max/mdev = 0.200/0.588/2.464/0.565 ms

# 抓docker0接口的包
[root@docker-server-node2 ~]# tcpdump -nn -i docker0 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on docker0, link-type EN10MB (Ethernet), capture size 262144 bytes

# docker0到另一台主机的包没有做SNAT转换，直接给10.100.0.2
19:49:05.331317 IP 10.200.0.2 > 10.100.0.2: ICMP echo request, id 218, seq 18, length 64
19:49:05.331825 IP 10.100.0.2 > 10.200.0.2: ICMP echo reply, id 218, seq 18, length 64
^C
2 packets captured
2 packets received by filter
0 packets dropped by kernel

# 抓eth0的包
[root@docker-server-node2 ~]# tcpdump -nn -i eth0 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes

# eth0的包做了SNAT转换，将10.200.0.2转换为了192.168.100.19
19:49:11.335877 IP 192.168.100.19 > 10.100.0.2: ICMP echo request, id 218, seq 24, length 64
19:49:11.336319 IP 10.100.0.2 > 192.168.100.19: ICMP echo reply, id 218, seq 24, length 64
^C
2 packets captured
2 packets received by filter
0 packets dropped by kernel
```

## 2.4 查看自定义网络信息

```bash
[root@docker-server-node1 ~]# docker network inspect cus-net
[
    {
        "Name": "cus-net",
        "Id": "1bdac1e7b929e2aa46d030e067fc469b119d74298ab815d46927a2046cb58dcd",
        "Created": "2020-02-27T17:15:31.006959586+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {            "Driver": "default",            "Options": {},            "Config": [                {                    "Subnet": "10.200.0.0/24",
                    "Gateway": "10.200.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "0ac566096fe9674732ac29cf81e49308813368b58bb0140a42df35f86c337804": {
                "Name": "nginx-node1-use-cus-net",
                "EndpointID": "1b9627082ee577562b4ff537da4e4834e189cf442b003d3661da78fb69f11c39",
                "MacAddress": "02:42:0a:c8:00:02",
                "IPv4Address": "10.200.0.2/24",
                "IPv6Address": ""
            },
            "df5816c94fe0637e05b2a5d0722078ae7ef132018f8d7b3b67a4af716b88f213": {
                "Name": "nginx-node2-use-cus-net",
                "EndpointID": "e64a8f45b86e318847b6d204487f473bbcd12ab668439746213cb900d31b8d57",
                "MacAddress": "02:42:0a:c8:00:03",
                "IPv4Address": "10.200.0.3/24",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

# 三. 启动使用默认的桥接网络的容器

```bash
[root@docker-server-node1 ~]# docker run -it -d --name default-net-con nginx:compiled_V1
b41090f73ff066d868c42d14ca15fe6b57bc188093c4557d8f792a62605fc506
[root@docker-server-node1 ~]# docker exec -it default-net-con /bin/bash
[root@b41090f73ff0 /]# cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
10.100.0.2      b41090f73ff0
[root@b41090f73ff0 /]# ping www.baidu.com
PING www.a.shifen.com (61.135.169.121) 56(84) bytes of data.
64 bytes from 61.135.169.121 (61.135.169.121): icmp_seq=1 ttl=127 time=5.85 ms
64 bytes from 61.135.169.121 (61.135.169.121): icmp_seq=2 ttl=127 time=18.5 ms
^C
--- www.a.shifen.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 5.858/12.219/18.581/6.362 ms
```

# 四. 实现使用不同网络的容器互相之间的通讯

## 4.1 Docker 提供的 iptables 规则

Docker 虽然提供了 bridge, host, overlay 等多种网络。使得运行多个容器的同
一个 Docker 宿主机上可以同时存在多个不同类型的网络。位于不同网络中的容器，
默认彼此之间是无法通信的。Docker 容器的跨网络隔离与通信，实质上是借助了 Linux
内核提供的 iptables 机制。

要实现使用默认 bridge 网络和自定义网络的容器之间的通讯，则需要修改 docker 提
供的 iptables 链。iptables 的 filter 表中默认划分为 IPNUT, FORWARD 和 OUTPUT
共 3 个链。但是目前为止，Docker 提供了四个链，分别为:

- DOCKER
- DOCKER-ISOLATION-STAGE-1
- DOCKER-ISOLATION-STAGE-2
- DOCKER-USER

查看 docker 默认的 iptables 规则：

```bash
root@ubuntu-suosuoli-node1:~# iptables -vnL
......
Chain DOCKER (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 ACCEPT     tcp  --  !docker0 docker0  0.0.0.0/0            172.17.0.2           tcp dpt:80

Chain DOCKER-ISOLATION-STAGE-1 (1 references)
 pkts bytes target     prot opt in     out     source               destination
 2844  132K DOCKER-ISOLATION-STAGE-2  all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0
 6118   13M RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain DOCKER-ISOLATION-STAGE-2 (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 DROP       all  --  *      docker0  0.0.0.0/0            0.0.0.0/0
 2844  132K RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0

Chain DOCKER-USER (1 references)
 pkts bytes target     prot opt in     out     source               destination
 6118   13M RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0
```

**Docker() 默认对宿主机的完整 iptables 规则为:**

```bash
root@ubuntu-suosuoli-node1:~# docker -v
Docker version 19.03.6, build 369ce74a3c
```

```bash
-A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
-A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
-A POSTROUTING -s 172.17.0.2/32 -d 172.17.0.2/32 -p tcp -m tcp --dport 80 -j MASQUERADE
-A DOCKER -i docker0 -j RETURN
-A DOCKER ! -i docker0 -p tcp -m tcp --dport 82 -j DNAT --to-destination 172.17.0.2:80
-A FORWARD -j DOCKER-USER
-A FORWARD -j DOCKER-ISOLATION-STAGE-1
-A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -o docker0 -j DOCKER
-A FORWARD -i docker0 ! -o docker0 -j ACCEPT
-A FORWARD -i docker0 -o docker0 -j ACCEPT
-A DOCKER -d 172.17.0.2/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 80 -j ACCEPT
-A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -j RETURN
-A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
-A DOCKER-ISOLATION-STAGE-2 -j RETURN
-A DOCKER-USER -j RETURN
```

## 4.2 Docker 提供的链

### 4.2.1 DOCKER 链

仅处理从宿主机到 docker0 的 IP 数据包。

### 4.2.2 DOCKER-ISOLATION 链

为了隔离在不同的 bridge 网络(默认的 bridge 和用户创建的 bridge 网络之间、
用户创建的不同 bridge 网络之间)之间的容器，Docker 提供 DOCKER-ISOLATION-1/2
两个阶段实现。DOCKER-ISOLATION-STAGE-1 链过滤源地址是 bridge 网络(默认
docker0)的 IP 数据包，匹配的 IP 数据包再进入 DOCKER-ISOLATION-STAGE-2 链处理，
不匹配就返回到父链 FORWARD 处理。在 DOCKER-ISOLATION-STAGE-2 链中，进一步处理
目的地址是 bridge 网络的 IP 数据包，匹配的 IP 数据包表示该 IP 数据包是从一个
bridge 网络的网桥发出，到另一个 bridge 网络的网桥的数据包，这样的 IP 数据包来自
其他 bridge 网络，将被直接 DROP；不匹配的 IP 数据包就返回到父链 FORWARD 继续进
行后续处理。

### 4.2.3 DOCKER-USER 链

在 Docker 启动时，会加载 DOCKER 链和 DOCKER-ISOLATION(DOCKER-ISOLATION-STAGE-1)
链中的过滤规则，并使之生效。绝对不能修改此链中的过滤规则。

如果用户要修改或者增加 Docker 的过滤规则，强烈建议追加到 DOCKER-USER 链。因为
DOCKER-USER 链中的过滤规则会先于 Docker 默认创建的规则被加载，从而能够覆盖
Docker 在 DOCKER 链和 DOCKER-ISOLATION 链中的默认过滤规则。例如，Docker 启动
后，默认任何外部 source IP 都被允许转发，从而能够从该 source IP 连接到宿主机上
的任何 Docker 容器实例。如果只允许一个指定的 IP 访问容器实例，可以插入路由规则
到 DOCKER-USER 链中，从而能够在 DOCKER 链之前被加载。例如：

```bash
# 只允许 192.168.100.18 访问容器
~$ iptables -A DOCKER-USER -i docker0 ! -s 192.168.100.18 -j DROP
# 只允许 192.168.100.0/24 网段中的 IP 访问容器
~$ iptables -A DOCKER-USER -i docker0 ! -s 192.168.100.0/24 -j DROP
# 只允许 192.168.100.1-192.168.120.2 网段中的 IP 访问容器(需要借助于 iprange 扩展匹配模块)
~$ iptables -A DOCKER-USER -m iprange -i docker0 ! --src-range 192.168.100.1-192.168.100.32-j DROP
```

### 4.2.4 Docker 在 nat 表中新增的规则

为了能够从容器中访问其他 Docker 宿主机，Docker 需要在 iptables
的 nat 表中的 POSTROUTING 链中插入转发规则，如：

```bash
root@ubuntu-suosuoli-node1:~# iptables -t nat -vnL
...
Chain POSTROUTING (policy ACCEPT 709 packets, 53848 bytes)
 pkts bytes target     prot opt in     out     source               destination
   15   986 MASQUERADE  all  --  *      !docker0  172.17.0.0/16        0.0.0.0/0
    0     0 MASQUERADE  tcp  --  *      *       172.17.0.2           172.17.0.2           tcp dpt:80
...

# 即是如下的规则
-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
-A POSTROUTING -s 172.17.0.2/32 -d 172.17.0.2/32 -p tcp -m tcp --dport 80 -j MASQUERADE
```

## 4.3 Docker 中禁止修改 iptables 过滤表

在 Docker 守护进程 dockerd 启动时，参数 `--iptables` 默认为 true，这表示允许
修改 iptables 规则表，要禁用该功能，可以有两个选择：

1. 设置启动参数`--iptables=false`
2. 修改配置文件`/etc/docker/daemon.json`，设置`"iptables": "false"`；
   然后执行 `systemctl reload docker`

## 4.4 默认网络和自定义网络的容器通讯

要实现使用默认 bridge 网络和自定义网络的容器之间的通讯，则需要修改 docker 提
供的 DOCKER-ISOLATION-STAGE-2 链的规则。

```bash
# 导出iptables规则
root@ubuntu-suosuoli-node1:~# iptables-save > /data/iptables.sh

# 编辑
root@ubuntu-suosuoli-node1:~# vim /data/iptables.sh
......
-A FORWARD -s 192.168.0.0/22 -j ACCEPT
-A FORWARD -s 192.168.100.0/22 -j ACCEPT
-A FORWARD -s 192.168.0.0/21 -j ACCEPT
-A DOCKER-ISOLATION-STAGE-1 -i br-1bdac1e7b929 ! -o br-1bdac1e7b929 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -i br-333954211ea9 ! -o br-333954211ea9 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -j RETURN
# -A DOCKER-ISOLATION-STAGE-2 -o br-1bdac1e7b929 -j DROP
# -A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
# -A DOCKER-ISOLATION-STAGE-2 -o br-333954211ea9 -j DROP
-A DOCKER-ISOLATION-STAGE-2 -j RETURN
-A DOCKER-USER -j RETURN
COMMIT
......

# 导入
root@ubuntu-suosuoli-node1:~# iptables-restore < iptables.sh
```

# 参考

https://docs.docker.com/network/bridge/
https://docs.docker.com/network/iptables/
https://blog.csdn.net/taiyangdao/article/details/88844558
