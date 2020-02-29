<h1><font face="黑体" color="grey">Docker 网络管理(3)-Docker网络类型</font></h1>

Docker 的网络子系统是以插件型式提供的，其使用驱动程序。默认提供多个驱动，
并使用这些驱动提供核心网络功能:

| 网络类型    | 说明                                                                                                                                                                                                                                   |
| :---------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bridge`    | Docker 创建容器使用的默认的网络驱动程序。如果没有指定驱动程序，默认为容器创建的网络类型就是 bridge。桥接网络通常用于应用程序在不同的容器中运行时需要通信的场景。                                                                       |
| `host`      | 使用 host 网络，容器直接使用宿主机的网络和 IP，这样可以消除容器和 Docker 主机之间的网络隔离，直接使用主机的网络。使用 host 网络时各容器之间及容器和主机之间通过 IP 和端口通讯，由于容器的 IP 都为宿主机 IP，所以各容器的端口不能相同。 |
| `container` | 使用 container 网络时，新创建的容器不会创建自己的虚拟网卡和 IP，而是和另一个容器共享 IP 和端口。                                                                                                                                       |
| `overlay`   | overlay 网络用来将多个 dockerd 服务连接在一起使其可以通讯，来支持 swarm 服务。                                                                                                                                                         |
| `none`      | 该网络模式会使得 docker 容器不进行任何的网络配置，没有网卡、IP 和路由等，相当于关闭容器网络功能。                                                                                                                                      |

另外，如果要实现大量 docker 容器之间大规模的网络通讯(容器分布于大量的不同宿
主机)，那必须借助于其它的网络插件，比如 Kubernetes 提供的相关网络功能来实现。

Docker 容器可以使用的网络驱动类型使用 `docker network ls` 命令就可以看到

```bash
root@ubuntu-suosuoli-node1:~# docker network ls/list
NETWORK ID          NAME                DRIVER              SCOPE
935309ce7aac        bridge              bridge              local
31f34546da91        host                host                local
726e2e52c926        none                null                local
```

看到有三种类型，下面介绍每一种类型的具体工作方式:

# bridge 网络

Bridge 网络模式，在创建容器时使用参数 `–-net=bridge` 指定，不指定默认就是
bridge 模式。查看当前 docker 提供的网络类型使用命令`docker network list`

```bash
root@ubuntu-suosuoli-node1:~# docker network list
NETWORK ID          NAME                DRIVER              SCOPE
935309ce7aac        bridge              bridge              local
31f34546da91        host                host                local
726e2e52c926        none                null                local

Bridge：# 桥接，使用自定义IP
Host：  # 不获取IP直接使用物理机IP，并监听物理机IP监听端口
None:   # 没有网络
```

[bridge 网络官方说明](https://docs.docker.com/network/bridge/)

从网络的角度来说，Docker 容器使用的桥接网络是一个链路层设备。网桥可以是
硬件设备或运行在主机内核中的软件设备。从 Docker 的角度来说，桥接网络是使
用软件桥来允许连接到同一桥接网络的容器进行通信的技术，同时提供与没有连接
到桥接网络的容器的隔离。Docker 网桥驱动程序会自动在主机上创建相关的规则，
这样不同桥接网络上的容器之间就不能直接通信。

桥接网络适用于运行在同一 Docker 守护进程(dockerd)主机上的容器。对于运行
在不同 Docker 守护进程主机上的容器之间的通信，可以在操作系统级别管理路由，
也可以使用`overlay network`。

启动 Docker 时，将自动创建一个默认的桥接网络，除非另外指定，否则新启动的
容器就连接到该桥接网络。还可以创建用户定义的桥接网络，用户定义的桥接网络
优于默认的桥接网络。

# Host 网络

Host 网络模式，在启动运行容器时使用选项 `–net=` 指定：`-net=host`启动的
容器如果指定了使用 host 模式，那么新创建的容器不会创建自己的虚拟网卡，而
是直接使用宿主机的网卡和 IP 地址，因此在容器里面查看到的 IP 信息就是宿主
机的信息，访问容器的时候直接使用宿主机 IP+容器端口即可，不过容器的其他资
源如文件系统、系统进程等还是和宿主机上的资源保持隔离。

此模式的网络性能最高，但是各容器之间端口不能相同，适用于运行容器端口比
较固定的业务。此时的容器相当于运行于主机上的普通进程。

## Host 网络示例

### 启动一个新容器指定网络模式为 host

```bash
root@ubuntu-suosuoli-node1:~# docker run -it -d --net=host --name nginx-host-net nginx-ubunt:v1
63055ebd78b4f618c9cd372021131698fb8f52e2369264a44d8605606b68e27b
root@ubuntu-suosuoli-node1:~# lsof -i:80
lsof: no pwd entry for UID 2019
COMMAND  PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   6546     root    6u  IPv4 253555      0t0  TCP *:http (LISTEN)
lsof: no pwd entry for UID 2019
nginx   6572     2019    6u  IPv4 253555      0t0  TCP *:http (LISTEN)
root@ubuntu-suosuoli-node1:~# pstree -p 6546
nginx(6546)───nginx(6572)
```

### 查看网卡信息

```bash
root@ubuntu-suosuoli-node1:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
63055ebd78b4        nginx-ubunt:v1      "nginx"             About a minute ago   Up About a minute                       nginx-host-net
root@ubuntu-suosuoli-node1:~# ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:caff:fe30:fb26  prefixlen 64  scopeid 0x20<link>
        ether 02:42:ca:30:fb:26  txqueuelen 0  (Ethernet)
        RX packets 2855  bytes 132048 (132.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 3282  bytes 13129732 (13.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.100.13  netmask 255.255.255.0  broadcast 192.168.100.255
        inet6 fe80::20c:29ff:fe7c:6f35  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:7c:6f:35  txqueuelen 1000  (Ethernet)
        RX packets 25434  bytes 24452569 (24.4 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 10097  bytes 903888 (903.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1814  bytes 604233 (604.2 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1814  bytes 604233 (604.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

### 访问宿主机 IP 验证

```bash
root@ubuntu-suosuoli-node1:~# docker exec -it nginx-host-net /bin/bash
root@ubuntu-suosuoli-node1:/# ls
apps  bin  boot  data  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

root@ubuntu-suosuoli-node1:/# cat /apps/nginx/conf/nginx.conf
......
  location / {
            root   /data/nginx/html;
            index  index.html index.htm;
        }
        ......

root@ubuntu-suosuoli-node1:/# cat /data/nginx/html/suosuoli/index.html
<DOCTYPE HTML/>
<head>
        <h1>A TEST MESSAGE... <h1/>
<head/>
<body>
        <p>Based alpine\'s nginx deployment.<span>NICE!<span/><p/>
<body/>

root@ubuntu-suosuoli-node1:/# exit
exit
```

![](png/2020-02-27-14-15-08.png)

### host 网络不支持端口映射

Host 模式不支持端口映射，当指定端口映射的时候会提示如下警告信息：

```bash
root@ubuntu-suosuoli-node1:~# docker run -it -d -p 88:80 --net=host nginx:compiled_V1
WARNING: Published ports are discarded when using host network mode  # host模式下端口暴露不支持
e94e5afca821336845839d93427648a39c380c1f89abf7c171cb3fa011267c11
```

# Container 网络

Container 网络，使用选项 `--net` 指定 : `--net=container:ID/NAME`。使
用此模式创建的容器需指定和一个已经存在的容器共享一个网络，而不是和宿主机
共享网，新创建的容器不会创建自己的网卡也不会配置自己的 IP，而是和一个已
经存在的被指定的容器共享同一 IP 和端口范围，因此这个容器的端口不能和被指
定的容器的已有端口冲突，除了网络之外的文件系统、进程信息等仍然保持相互隔
离，两个容器的进程可以通过 lo 网卡及容器 IP 进行通信。

## container 网络示例

### 启动一个使用桥接网络的容器

```bash
root@ubuntu-suosuoli-node1:~# docker run -it -d -p 82:80 --name bridge-jerry --net=bridge  nginx:compiled_V1
8e208504f3766be7ae95ba1423cf3eb1fbda50eb376ca40c1d9b355a45ac2521
root@ubuntu-suosuoli-node1:~# lsof -i:82
COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
docker-pr 7656 root    4u  IPv6 273753      0t0  TCP *:82 (LISTEN)
```

### 启动另一个容器并指定 container 网络

```bash
root@ubuntu-suosuoli-node1:~# docker run -it -d --name share-net-from-jerry --net=container:bridge-jerry tomcat-business:app1
d2c55928d72afddf5bfade1f40dfa7a938c5d173109da2d641f33e5864d3c655

root@ubuntu-suosuoli-node1:~# docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                         NAMES
d2c55928d72a        tomcat-business:app1   "/apps/tomcat/bin/ru…"   15 seconds ago      Up 13 seconds                                     share-net-from-jerry
8e208504f376        nginx:compiled_V1      "nginx -g 'daemon of…"   5 minutes ago       Up 5 minutes        443/tcp, 0.0.0.0:82->80/tcp   bridge-jerry

```

### 验证

#### nginx 的 hosts

```bash
root@ubuntu-suosuoli-node1:~# docker exec -it bridge-jerry /bin/bash
[root@8e208504f376 /]# cat /etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.2	8e208504f376   # tomcat同样解析该条目

[root@8e208504f376 /]# ip addr show eth0
14: eth0@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever

[root@8e208504f376 /]# exit
exit
```

#### tomcat 的 hosts

```bash
root@ubuntu-suosuoli-node1:~# docker exec -it share-net-from-jerry /bin/bash
[root@8e208504f376 /]# cat /etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.2	8e208504f376  # nginx容器同样使用该解析条目

[root@8e208504f376 /]# ip addr show eth0
14: eth0@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever

[root@8e208504f376 /]# exit
exit
```

# none

None 模式，其实就是关闭容器的网络功能，使用 `–-net=none` 指定。在使用 none
模式后，Docker 容器不会进行任何网络配置，其没有网卡、没有 IP 也没有路由，因
此默认无法与外界通信，需要手动添加网卡配置 IP 等，所以极少使用。

```bash
root@ubuntu-suosuoli-node1:~# docker run -it -d --name none-net --net=none nginx:compiled_V1
00c851e6a5c0782925e6934a932f78341849a9e75a91ba3bced0e05e97f2f996
root@ubuntu-suosuoli-node1:~# docker exec -it none-net /bin/bash
[root@00c851e6a5c0 /]# cat /etc/hosts
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
[root@00c851e6a5c0 /]# ifconfig
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[root@00c851e6a5c0 /]# exit
exit
```
