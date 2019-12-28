<center><font size=6>Linux39 期 第二次阶段考试</font></center>

# 一.简答实验题(5 分/题)

1. 请写出 5 个你熟悉的 Linux 软件服务的网络端口号和对应的软件名称。

| 服务   | 端口            |
| ------ | --------------- |
| HTTPD  | 80              |
| MySQL  | 3306            |
| ftp    | 21              |
| sshd   | 22              |
| telnet | 23              |
| samba  | 137,138,139,445 |
| NFS    | 111             |
| rsync  | 873             |
| smtp   | 25              |

2. 使用 ansible playbook 创建 20 个普通用户，用户名为 magedu01
   到 magedu20，用户密码为 Linux2019@39

- 1.添加主机列表

  ```bash
  root@ubuntu1904:/data#vim /etc/ansible/hosts
  [user]
  172.20.2.37
  ```

- 2.创建用户名列表
  `root@ubuntu1904:/data#vim users.yml`

  ```yaml
  ---
  users:
    - username: magedu01
    - username: magedu02
    - username: magedu03
    - username: magedu04
    - username: magedu05
    - username: magedu06
    - username: magedu07
    - username: magedu08
    - username: magedu09
    - username: magedu10
    - username: magedu11
    - username: magedu12
    - username: magedu13
    - username: magedu14
    - username: magedu15
    - username: magedu16
    - username: magedu17
    - username: magedu18
    - username: magedu19
    - username: magedu20
  ```

- 3.加密用户秘钥
  `root@ubuntu1904:/data#openssl passwd -1 "Linux2019@39"`
  `$1$2atTwjfF$KvRtM7otQ63jmFwnR41yR1`

- 4.编写 playbook
  `root@ubuntu1904:/data#vim create_user.yml`

  ```yml
  ---
  - hosts: user
    remote_user: root
    vars:
      - username: magedu
      - password: "$1$2atTwjfF$KvRtM7otQ63jmFwnR41yR1"
    vars_files:
      - users.yml

    tasks:
      - name: create users
        user: name={{ item.username }} password={{ password }}
        with_items: "{{ users }}"
  ```

- 5.检查语法

  ```bash
  root@ubuntu1904:/data#ansible-playbook -C create_user.yml  -k
  SSH password:

  PLAY [user] *************************************************************************************************************************

  TASK [Gathering Facts] **************************************************************************************************************
  ok: [172.20.2.37]

  TASK [create users] *****************************************************************************************************************
  changed: [172.20.2.37] => (item={'username': 'magedu01'})
  changed: [172.20.2.37] => (item={'username': 'magedu02'})
  changed: [172.20.2.37] => (item={'username': 'magedu03'})
  changed: [172.20.2.37] => (item={'username': 'magedu04'})
  changed: [172.20.2.37] => (item={'username': 'magedu05'})
  changed: [172.20.2.37] => (item={'username': 'magedu06'})
  changed: [172.20.2.37] => (item={'username': 'magedu07'})
  changed: [172.20.2.37] => (item={'username': 'magedu08'})
  changed: [172.20.2.37] => (item={'username': 'magedu09'})
  changed: [172.20.2.37] => (item={'username': 'magedu10'})
  changed: [172.20.2.37] => (item={'username': 'magedu11'})
  changed: [172.20.2.37] => (item={'username': 'magedu12'})
  changed: [172.20.2.37] => (item={'username': 'magedu13'})
  changed: [172.20.2.37] => (item={'username': 'magedu14'})
  changed: [172.20.2.37] => (item={'username': 'magedu15'})
  changed: [172.20.2.37] => (item={'username': 'magedu16'})
  changed: [172.20.2.37] => (item={'username': 'magedu17'})
  changed: [172.20.2.37] => (item={'username': 'magedu18'})
  changed: [172.20.2.37] => (item={'username': 'magedu19'})
  changed: [172.20.2.37] => (item={'username': 'magedu20'})

  PLAY RECAP **************************************************************************************************************************
  172.20.2.37                : ok=2    changed=1    unreachable=0    failed=0
  ```

- 6.运行 ansible-playbook

  ```bash
  root@ubuntu1904:/data#ansible-playbook create_user.yml  -k
  SSH password:

  PLAY [user] ****************************\*\*\*\*****************************\*****************************\*\*\*\*****************************

  TASK [Gathering Facts] **************************\*\***************************\*\***************************\*\***************************
  ok: [172.20.2.37]

  TASK [create users] **************************\*\*\*\***************************\***************************\*\*\*\***************************
  changed: [172.20.2.37] => (item={'username': 'magedu01'})
  changed: [172.20.2.37] => (item={'username': 'magedu02'})
  changed: [172.20.2.37] => (item={'username': 'magedu03'})
  changed: [172.20.2.37] => (item={'username': 'magedu04'})
  changed: [172.20.2.37] => (item={'username': 'magedu05'})
  ......
  ```

- 7.确认

  ```bash
  root@ubuntu1904:/data#ssh 172.20.2.37
  root@172.20.2.37's password:
  Last login: Wed Dec 25 19:29:15 2019 from 172.20.1.33
  [root@node1 ~]# id magedu01
  uid=1003(magedu01) gid=1003(magedu01) groups=1003(magedu01)
  [root@node1 ~]# id magedu02
  uid=1004(magedu02) gid=1004(magedu02) groups=1004(magedu02)
  [root@node1 ~]# id magedu03
  uid=1005(magedu03) gid=1005(magedu03) groups=1005(magedu03)
  [root@node1 ~]# id magedu20
  uid=1022(magedu20) gid=1022(magedu20) groups=1022(magedu20)
  [root@node1 ~]# id magedu17
  uid=1019(magedu17) gid=1019(magedu17) groups=1019(magedu17)
  [root@node1 ~]# getent shadow magedu20
  magedu20:$1$FZsY2PLA$BfqjMAHdWG1xI3DnEPgPT.:18255:0:99999:7:::
  ```

3. 使用 crontab 任务计划，在每月 22 号晚上 9 点到晚上 11 点之间每
   5 钟执行一次 /root/backup.sh 脚本文件

- 答：
  ```bash
  [root@node1 ~]# crontab -e
  */5 21-23 22 * * /bin/bash  /root/backup.sh
  [root@node1 ~]# crontab -l
  */5 21-23 22 * * /bin/bash  /root/backup.sh
  或者
  [root@node1 ~]# echo '*/5 21-23 22 * * /bin/bash  /root/backup.sh' > /var/spool/cron/root
  ```

4. 请写出在 CentOS6.10 和 Ubuntu1804 版本中永久修改主机名为 magedu.org 过程

- 答：

  ```bash
  # centos6
  [root@node1 ~]# vim /etc/hostname
  magedu.org
  [root@node1 ~]# cat /etc/hostname
  magedu.org
  [root@node1 ~]# hostname magedu.org
  [root@node1 ~]# exit

  # Ubuntu1904
  root@ubuntu1904:/data#vim /etc/hostname
  magedu.org
  root@ubuntu1904:/data#cat /etc/hostname
  magedu.org
  root@ubuntu1904:/data#hostname magedu.org
  root@ubuntu1904:/data#exit
  ```

5. 请写出 CentOS6.10，CentOS7.7，Ubuntu1804 中配置静态网络地址的过程，ip 地址为 192.168.100.100 子网掩码为 255.255.255.0

- 答：

  ```bash
  # centos6
  [root@centos6 ~]#vim /etc/sysconfig/network-scripts/ifcfg-eth0
  DEVICE=eth0
  TYPE=Ethernet
  HWADDR=00:0C:29:63:53:DA
  IPADDR=192.168.100.100
  NETMASK=255.255.255.0
  GATEWAY=192.168.100.1
  BOOTPROTO=static
  NAME="eth0"
  NM_CONTROLLED=no
  ONBOOT=yes

  # centos7
  [root@centos7 ~]# vim /etc/sysconfig/network-scripts/ifcfg-ens37
  TYPE=Ethernet
  BOOTPROTO=static
  DEFROUTE=yes
  NAME=ens37
  DEVICE=ens37
  ONBOOT=yes
  IPADDR=192.168.100.100
  NETMASK=255.255.255.0
  GATEWAY=192.168.100.1

  # Ubuntu
  root@ubuntu1904:~#vim /etc/netplan/01-netcfg.yaml
  network:
      version: 2
      renderer: networkd
      ethernets:
          eth0:
              addresses:
                  - 192.168.100.100/24
              gateway4: 192.168.100.1
              nameservers:
                  addresses: [144.144.144.144, 8.8.8.8, 1.1.1.1]
  ```

6. 请说出为什么在 ping 服务器地址时不需要指明端口号的原因

- 答：
- ping 使用 ICMP 协议来进行诊断网络是否可达，ICMP 属于网络层协议，
  一般用于发送和交换错误信息；而端口常用来完成不同主机的进程间通信，
  需要配合使用传输层协议如 TCP/UDP 协议，所以 ping 是不需要指明端口的。

7. 使用 awk 统计统计处理以下文件中每种域名出现的次数

```
http://www.baidu.com/index.html
http://www.baidu.com/1.html
http://post.baidu.com/index.html
http://mp3.baidu.com/index.html
http://www.baidu.com/3.html
ftp://files.github.io/k8s.img
http://post.baidu.com/2.html
```

- 答：

  ```bash
  [root@centos7 ~]# cat awk_test
  http://www.baidu.com/index.html
  http://www.baidu.com/1.html
  http://post.baidu.com/index.html
  http://mp3.baidu.com/index.html
  http://www.baidu.com/3.html
  ftp://files.github.io/k8s.img
  http://post.baidu.com/2.html
  [root@centos7 ~]# awk -F'/' 'BEGIN{printf"Domain                   Freq\n\n"}{domain[$3]++}END{for (d in domain){printf"%25-s %12-s\n", d,domain[d]}}' awk_test
  Domain                   Freq

  files.github.io           1
  post.baidu.com            2
  www.baidu.com             3
  mp3.baidu.com             1
  ```

8. CentOS7.6 系统中如何禁用 firewalld 服务？ 禁用 firewalld
   后，请写出 iptables 规则，要求仅对外开放 TCP 协议的 22、80、
   443 端口; 配置生效后，如何才能确保系统重启后自动完成刚才的 iptables 规则配置？

- 答：

  ```bash
  [root@centos7 ~]# systemctl status firewalld
  [root@centos7 ~]# systemctl disable --now firewalld
  [root@centos7 ~]# systemctl status firewalld
  [root@centos7 ~]# iptables -t filter -A INPUT -p tcp -m multiport --dports=22,80,443 -j ACCEPT
  [root@centos7 ~]# iptables -t filter -A INPUT -j DROP
  # 开机加载法一
  [root@centos7 ~]# iptables-save > /data/ip_rules
  [root@centos7 ~]# vim /etc/rc.d/rc.local
  iptables-restore < /data/ip_rules
  # 开机加载法二
  [root@centos7 ~]# yum install iptables-services
  [root@centos7 ~]# iptables-save > /etc/sysconfig/iptables
  [root@centos7 ~]# systemctl enable iptables.service
  ```

9. 请简述 httpd 的三种工作模式以及他们的特点（prefork, worker, Event）

- 答：
- 三种模式都是 httpd 的 MPM 多路处理模块提供的功能，它们的主要区别为是否是基于线程级
  的服务和请求处理，以及是否是多进程多线程 I/O 复用。
  1. **`prefork`**:**多进程 I/O 模型**；在 prefork 模式中，随着 httpd 服务的启动，
     系统会创建一个父进程，该进程负责创建和启动固定数量的子进程且不响应请求，子进程则侦听请求并
     在请求到达时提供服务。Apache httpd 总是会试图维护几个备用或空闲的服务进程，它们
     随时准备为到来的请求提供服务。通过这种方式，客户端不需要等待新的子进程被创建，
     然后他们的请求才能被服务。该模式比较稳定，但是维护了一些空闲进程，会占内存。
  2. **`worker`**:在 worker 模式中，随着 httpd 服务的启动，系统会创建一个 httpd
     主进程，该进程(**父进程**)负责创建子进程。每个子进程又会创建一个固定数量的服务
     线程(在`ThreadsPerChild`指令中指定)，以及一个**监听器线程**，监听请求并在请求
     到达时将其传递给**服务线程**进行处理。Apache HTTP 服务器会维护一个**备用或空闲**
     **的服务线程池**，随时为传入的请求提供服务。这样，客户端就不需要等待新线程或
     新进程的创建，然后才能处理他们的请求。初始启动的进程数量由`StartServers`指令
     设置。在提供服务期间，服务器会评估所有进程中空闲线程的总数，并 fork(创建)或
     杀死进程，以将这个数保持在`MinSpareThreads`和`MaxSpareThreads`指定的范围内。
     这个过程是自动调节的，一般不用手动修改。通过使用线程来服务请求，与基于进程的
     服务相比，它能够使用更少的系统资源来服务大量请求。它通过保持多个进程可用(每个
     进程又有多个线程)，在很大程度上保持了基于进程的服务(prefork)的稳定性。
  3. **`event`**:事件驱动模型，基于 worker 模型发展而来。它实现了混合的多进程多线程服务
     模型，httpd 服务会创建一个父进程，该父进程创建多个子进程，每个子进程创建固定数量
     的服务线程(`ThreadsPerChild`指令中指定)，以及一个监听线程(监听请求并在请求到达
     时将其传递给服务线程进行处理)。在该模式中，在客户端完成第一个请求后，可以保持
     连接打开，客户端使用相同的套接字发送更多的请求，这样在创建 TCP 连接时可以节省大量
     开销。然而，Apache HTTP 服务器以往的做法是保持整个子进程/线程等待来自客户端的请求，
     这样会浪费资源，且在高并发下性能跟不上。为了解决这个问题，event 模式的每个进程
     使用一个专用的监听线程来处理:在监听的`sockets`、处于`keep-alive`状态的所有`sockets`
     以及完成大部分工作只剩发送数据给客户端的`sockets`。这样就提高了在高并发
     场景下的处理能力。

10. CentOS7 系统有几个运行级别？ 分别是什么？ 如何将默认运行级别调整为字符界面？

- 答： CentOS7 有 7 个运行级别：在`/usr/lib/systemd/system/`文件夹下的 target 表示了
  相关的运行级别，可以通过创建 default.target 软连接指向相应的级别来开机进入该级别

```bash
运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
运行级别2：多用户状态(没有NFS)
运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
运行级别4：系统未使用，保留
运行级别5：X11控制台，登陆后进入图形GUI模式
运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动
```

```bash
[root@centos7 ~]# ll /usr/lib/systemd/system/*level*.target
lrwxrwxrwx. 1 root root 15 Dec 15 19:16 /usr/lib/systemd/system/runlevel0.target -> poweroff.target
lrwxrwxrwx. 1 root root 13 Dec 15 19:16 /usr/lib/systemd/system/runlevel1.target -> rescue.target
lrwxrwxrwx. 1 root root 17 Dec 15 19:16 /usr/lib/systemd/system/runlevel2.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Dec 15 19:16 /usr/lib/systemd/system/runlevel3.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Dec 15 19:16 /usr/lib/systemd/system/runlevel4.target -> multi-user.target
lrwxrwxrwx. 1 root root 16 Dec 15 19:16 /usr/lib/systemd/system/runlevel5.target -> graphical.target
lrwxrwxrwx. 1 root root 13 Dec 15 19:16 /usr/lib/systemd/system/runlevel6.target -> reboot.target

# 获取默认运行级别
[root@centos7 ~]# systemctl get-default
multi-user.target
# 设置运行级别
[root@centos7 ~]# systemctl set-default graphical.target
Removed symlink /etc/systemd/system/default.target.
Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/graphical.target.
```

# 二.扩展题：（每题 25 分）

1. 使用 shell 脚本完成在一台 CentOS7 中编译安装 httpd2.4.39 和 php7.3.5 的 fpm
   模式，实现 httpd 通过 socket 与 fpm 通信， 响应 phpinfo 信息页面请求，请写出
   详细过程。

```bash
#!/bin/bash
WORK_DIR="/data"
apr_pkg="apr-1.7.0.tar.bz2"
apr_dir="apr-1.7.0"
apr_util_pkg="apr-util-1.6.1.tar.bz2"
apr_util_dir="apr-util-1.6.1"
httpd_pkg="httpd-2.4.39.tar.gz"
httpd_dir="httpd-2.4.39"
deps_httpd="gcc pcre-devel openssl-devel expat-devel"
compile_opt_httpd="--prefix=/app/httpd24 --enable-so --enable-ssl --enable-cgi --enable-rewrite --with-zlib --with-pcre --enable-modules=most --enable-mpms-shared=all --with-mpm=prefork --with-included-apr"
deps_php73="gcc libxml2-devel bzip2-devel libmcrypt-devel"
php_pkg73="php-7.3.5.tar.xz"
php_dir73="php-7.3.5"
compile_opt73: "--prefix=/app/php73 --enable-mysqlnd --with-mysqli=mysqlnd --with-openssl --with-pdo-mysql=mysqlnd --enable-mbstring --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --enable-sockets --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --enable-maintainer-zts --disable-fileinfo"

#### httpd ####

cd ${WORK_DIR}

# install deps&libs
yum install -y ${deps_httpd}

# unarchive
tar -jxf ${apr_pkg} -C /usr/local
tar -jxf ${apr_util_pkg} -C /usr/local
tar -zxf ${httpd_pkg} -C /usr/local

# merge libs
cp -a /usr/local/${apr_dir} /usr/local/${httpd_dir}/libsrc/apr
cp -a /usr/local/${apr_util_dir} /usr/local/${httpd_dir}/libsrc/apr-util

# compile
cd /usr/local/${httpd_dir}/
./configure ${compile_opt_httpd}
make -j 4 && make install

# configure PATH
echo 'PATH=/usr/local/mysql/bin/:/app/httpd24/bin:$PATH' > /etc/profile.d/httpd.sh

# config homepage and status page
cat > /data/httpd24/htdocs/index.html  <<EOF
<DOCTYPE html>
<head>
        <p1>Hello There!</p1>
</head>
<body>
        <a>A test message!!</a>
</body>
EOF

cat > /data/httpd24/htdocs/index.php <<EOF
<?php
phpinfo();
?>
EOF

# configuration
cp /app/httpd24/httpd.{conf,.conf.bak}
cat >> /app/httpd24/conf/httpd.conf <<EOF
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
AddType application/x-httpd-php .php
AddType application/x-httpd-php-source .phps
ProxyRequests Off
ProxyPassMatch ^/(.*\.php)$ "unix:/run/php-fpm.sock|fcgi://localhost/data/httpd24/htdocs/"
ProxyPassMatch ^/(status|ping)$ "unix:/run/php-fpm.sock|fcgi://localhost/"
EOF

sed -nr 's/(^ +DirectoryIndex ).*/\1 index.php index.html/' /app/httpd24/conf/httpd.conf

/app/httpd24/bin/apachectl restart

#### httpd end ####

####  php start ####

cd ${WORK_DIR}

# install deps&libs
yum install -y ${deps_php73}

# unarchive pkg
tar -Jxf ${php_pkg73} -C /usr/local

# compile
cd /usr/local/${php_dir73}/
./configure ${compile_opt73}
make -j 4 && make install

# get configuration file ready
cp /usr/local/${php_dir73}/php.ini-production  /etc/php.ini
cp /usr/local/${php_dir73}/aspi/fpm/php-fpm.service /usr/lib/systemd/system
cp /app/php73/etc/php-fpm.default /app/php/73/etc/php-fpm.conf
cp /app/php73/etc/php-fpm.d/www.conf.default  /app/php73/etc/php-fpm.d/www.conf

# modify conf options
sed -nri.bak 's/^user.*/user = apache/' /app/php73/etc/php-fpm.d/www.conf
sed -nri 's/^group.*/group = apache/' /app/php73/etc/php-fpm.d/www.conf
sed -nri 's#^;(pm.status_path = /status)$#\1#' /app/php73/etc/php-fpm.d/www.conf
sed -nri 's#^;(ping.path = /ping)$#\1#' /app/php73/etc/php-fpm.d/www.conf

mkdir /etc/php.d
cat > /etc/php.d/opcache.ini <<EOF
[opcache]
zend_extension=opcache.so
opcache.enable=1
EOF

# PATH conf
echo 'PATH=/app/php73/bin:$PATH' > /etc/profile.d/php.sh

# reload service and start
systemctl daemon-reload
systemctl enable --now  php-fpm.service

# change to listening local socket
sed -nri.bak 's/^listen = 127.0.0.1:9000/listen = /run/php-fpm.sock/' /app/php73/etc/php-fpm.d/www.conf
sed -nri 's/^listen.owner =.*/listen.owner = apache/' /app/php73/etc/php-fpm.d/www.conf
sed -nri 's/^listen.group =.*/listen.group = apache/' /app/php73/etc/php-fpm.d/www.conf
sed -nri 's/^listen.mode =.*/listen.mode = 0660/' /app/php73/etc/php-fpm.d/www.conf
systemctl restart php-fpm
####  php end ####

#### test ####
curl http://server-ip/ping | grep "pong" && {clear; echo "Nice.";}
curl http://server-ip/ | grep "PHP Version" && {clear; echo "All done.";}
#### test ####

unset WORK_DIR
unset apr_pkg
unset apr_dir
unset apr_util_pkg
unset apr_util_dir
unset httpd_pkg
unset httpd_dir
unset deps_httpd
unset compile_opt_httpd
unset deps_php73
unset php_pkg73
unset php_dir73
unset compile_opt73
```

2. httpd 服务器的访问日志保存在容量为 1T 的 /dev/sdb 磁盘中，对应的挂载路径
   为/data/log，编写一个 shell 脚本，每隔一个小时测试一下该磁盘的使用率是否
   超过 60%，如果超过立刻将 2 天之前的日志移动到远程服务器 172.18.0.100 服务
   器上，移动完成后，如果磁盘空间使用率依旧大于 70%, 则发邮件给 1794379915@qq.com
   提示报警。请写出操作的主要过程。

- 答：

  编写脚本

  ```bash
  #!/bin/bash
  ##/data/check_disk.sh
  D_MAX=`df -h | grep -E "/dev/sdb" | egrep -o "[0-9]{,3}%" | cut -d% -f1 | sort -nr | head -n1`
  THREAD_D=60
  THREAD_NOTIFY=70

  yum install -y expect sshpass
  expect <<EOF
  spawn ssh-keygen
  expect {
  "Enter" { send "\n";exp_continue }
  "Enter" { send "\n";exp_continue }
  "Enter" { send "\n";exp_continue }
  }
  EOF
  sshpass -p remotepass ssh-copy-id 172.18.0.100

  if [[ $D_MAX -gt $THREAD_D ]]; then
      #echo -e "\e[1;31mWarning!\nThe disk(/dev/adb) space is exceed 60%.\e[0m"
      #echo "Moving old logs to 172.18.0.100:/data..."
      find /data/log/ -type f -mtime +2 -exec rsync {} 172.18.0.100:/data/ \;
      [ "$?" -eq 0 ] && \
        {
           find /data-http-log/ -type f -mtime +2 -delete;
        } || echo "Disk \"/dev/sdb\" almost full(exceed 60%), move files failed, please take some action." \
        | mail -s "Backup fialed." 1794379915@qq.com
  elif [[ $D_MAX -gt $THREAD_NOTIFY ]]; then
      #echo -e "\e[1;31mWarning!\nThe disk(/dev/adb) space is still exceed 70%.\e[0m"
      echo "Disk \"/dev/sdb\" almost full(exceed 70%), please take some action." | mail -s "Disk full" 1794379915@qq.com
  else
      #echo -e "\e[1;32mDisk /dev/sdb space fine.\e[0m"
      exit 0
  fi

  unset D_MAX
  unset THREAD_D
  unset THREAD_NOTIFY
  ```

  编写计划任务

  ```bash
  [root@localhost ~]# crontab -e
  * */1 * * * /bin/bash /data/check_disk.sh
  [root@localhost ~]# crontab -l
  * */1 * * * /bin/bash /data/check_disk.sh
  或者
  [root@localhost ~]# echo '* */1 * * * /bin/bash  /data/check_disk.sh' > /var/spool/cron/root
  ```
