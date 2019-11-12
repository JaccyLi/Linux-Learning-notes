# 实验:使用kickstart和anaconda自动化安装centos系统

## anaconda 介绍

## kickstart 介绍

## 部属安装过程

### 实验基础

```py
1.已经在如Vmware等虚拟机上安装好了centos6或者centos7，在centos8上使用kickstart软件需要有一个RHEL账户
2.需要安装的系统的光盘镜像
```

### 1.搭建httpd服务来提供系统安装源(以后需要给某台主机安装系统就直接通过网络从此服务器得到安装的系统)

- centos6

```py
rpm -q httpd
yum install httpd
chkconfig httpd on
service httpd start
service httpd status
```

- 默认服务文件夹`/var/www/html`

- 新建一个文件夹来放安装源
`mkdir -p /var/www/html/centos/{6,7,8}/os/x86_64`

- 挂载需要安装的光盘镜像到目录`/var/www/html`
`mount /dev/sr0 /var/www/html`

- centos7
- 默认服务文件夹`/var/www/html`

```py
rpm -q httpd
yum install httpd
systemctl enable httpd
systemctl start httpd
systemctl status httpd
```

- 挂载需要安装的光盘镜像到目录`/var/www/html`
`mount /misc/cd /var/www/html` 或者 `mount /dev/sr0 /var/www/html`

- centos8

```py

```

### 2

### 3.

### 4.

### 5.

### 6.

- ks6.cfg

```py
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use network installation
url --url="http://172.20.2.44/cenos6"
# Root password
rootpw --iscrypted $1$ytz4LhHy$Od9bcU9XnM8gDuL0LuY/J0
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
# System keyboard
keyboard us
# System language
lang en_US
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# Installation logging level
logging --level=info
# Reboot after installation
reboot
# System timezone
timezone  Asia/Shanghai
# Network information
network  --bootproto=static --device=eth0 --gateway=172.20.3.1 --ip=172.20.3.112 --nameserver=144.144.144.144 --netmask=255.255.255.0 --onboot=on
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 
# Disk partitioning information
part /boot --fstype="ext3" --size=1024
part / --fstype="ext4" --size=10240
part data --fstype="ext4" --size=10240

%post
useradd stevenux
echo 123456 | passwd --stdin stevenux
%end
```

- ks7.cfg

```py
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --iscrypted $1$q5kgkOfe$9uxwxHzrapS5h4J.9XJ8c1
# Use network installation
url --url="http://172.20.3.82/centos"
# System language
lang en_US
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx

# Firewall configuration
firewall --disabled
# Network information
network  --bootproto=static --device=ens33 --gateway=172.20.3.1 --ip=172.20.3.111 --nameserver=144.144.144.144 --netmask=255.255.255.0
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --fstype="ext3" --size=1024
part / --fstype="xfs" --size=10240
part /data --fstype="xfs" --size=10240

%post
useradd stevenux
echo 123456 | passwd --stdin stevenux
%end
```

- ks8.cfg

```py
#version=RHEL8
ignoredisk --only-use=sda
# Partition clearing information
zerombr
text
reboot

clearpart --all --initlabel

firewall --disabled
selinux --disabled

# Use graphical install

repo --name="AppStream" --baseurl=http://172.20.3.80/centos/8/os/x86_64/AppStream
# Use CDROM installation media
# cdrom # url --url http://
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8
# Network information
# network  --bootproto=static --device=ens160 --gateway=172.20.3.1 --ip=172.20.3.113 --nameserver=144.144.144.144 --netmask=255.255.255.0 --onboot=on 
network  --bootproto=dhcp --device=ens160 --ipv6=auto --activate
network  --hostname=centos8.localdomain
# Root password
rootpw --iscrypted $6$JrooqXF37Q2lI4si$05OlIYoqLH8uV/1CqvCJUReL5POu9XL5Z2olZ7FtiQYVi1zKCZgDqbBTc.gLnT7trUBX55xGS6MX8bKx0VLKv1
# X Window System configuration information
# xconfig  --startxonboot
# Run the Setup Agent on first boot

firstboot --enable
# Do not configure the X window system
skipx
# System services
services --disabled="chronyd"
# System timezone
timezone Asia/Shanghai --isUtc --nontp
user --name=steve --password=$6$NsKlQVGMrkJgfJtr$1CZdKd0XAokuHgutLdDI9SVVw3wit0L55OLiQDdwd9bQw2b4ElQYUDGp0tl.GUl2y9oaa4GSfmewktOu8m5my1 --iscrypted --gecos="steve"
# Disk partitioning information
part / --fstype="xfs" --ondisk=sda    --size=10240
part /data --fstype="xfs" --ondisk=sda --size=10240
part swap --fstype="swap" --ondisk=sda --size=2048
part /boot --fstype="ext4" --ondisk=sda   --size=1024

%packages
@^minimal-environment
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

%post
useradd stevenux
echo 123456 | passwd --stdin stevenux
%end
```
