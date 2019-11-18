# :arrow_forward:实验：使用NTP服务和chronyd服务实现时间同步

## :one:前提条件

### centos6

- 确认ntpd服务状态和配置文件

```py
rpm -ql ntp
chkconfig ntpd on
service start ntpd
ss -unlp
```

- 编辑/etc/ntpd.conf,注释原来的国外的ntp服务器

```py
添加：
server ntp.aliyun.com iburst
server ntp1-7.aliyun.com iburst
```

### centos7,8

- 服务unit文件：`/usr/lib/systemd/system/chronyd.service`
- 配置文件：`/etc/chrony.conf`
- 监听的端口：`323/udp,123/udp`
- 确认chronyd服务的状态

```py
rpm -ql chrony
yum install chrony
systemctl status chronyd.seervice
systemctl start chronyd.seervice
```

- 编辑/etc/chrony.conf,注释原来的国外的ntp服务器,并添加阿里的公共ntp服务器

```py
添加：
server ntp.aliyun.com iburst
server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
server ntp3.aliyun.com iburst
server ntp4.aliyun.com iburst
server ntp5.aliyun.com iburst
server ntp6.aliyun.com iburst
server ntp7.aliyun.com iburst
```

## :two:若要将centos6作为ntp服务器来当作其它主机的时间同步源，则需要配置:

- 编辑修改/etc/ntpd.conf

```py
添加:
server 172.20.3.82 iburst
更改:
restrict default nomodify notrap nopeer noquery --> restrict default nomodify
service ntpd start   启动服务
chkconfig ntpd on    开机启动
ss -unl              确认监听udp/123
```

- 确保本机和客户机(请求同步时间的主机)通讯正常
- 确保172.20.3.82主机的ntpd或者chronyd服务已经开通

## :three:若要将centos7,8作为ntp服务器来当作其它主机的时间同步源，则需要配置:

- 编辑修改/etc/chronyd.conf

```py
注释server开头的行
添加阿里的公共ntp服务器域名
ntp.aliyun.com iburst

添加本地可连接本机同步的主机
allow 192.168.0.0/16

即使本机时间未和阿里的ntp服务器时间同步，也向本地的其它主机提供时间同步服务
local stratum 10
```

- **注意：在ccentos6中，若chronyd服务已开启，则不能手动使用ntpdate同步时间。**

## :arrow_left:exit
