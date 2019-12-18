<center><font face="黑体" color="#87cefa" size="5">LAMP(4)_编译安装LAMP</font></center>


# 一.CentOS 7 编译安装基于 FastCGI 的 LAMP

实验环境：
: 主机A: MariaDB
: 主机B: HTTPD+PHP(FastCGI)
: 软件及版本
`mariadb-10.2.27-linux-x86_64.tar.gz 通用二进制格式`
`apr-1.7.0.tar.bz2`
`apr-util-1.6.1.tar.bz2`
`httpd-2.4.41.tar.gz`
`php-7.3.10.tar.xz`
`wordpress-5.2.3-zh_CN.zip`
`Discuz_X3.4_SC_UTF8【20190917】.zip`

安装部署LAMP的一般步骤：
: 准备安装包
: 二进制安装MariaDB
: 编译安装HTTPD
: 编译安装PHP(基于HTTPD模块方式或者基于PHP-FPM方式)
: 编辑HTTPD配置文件以支持PHP

## 1.1 二进制安装 MariaDB

二进制安装MariaDB的一般步骤：
: 1. 创建`myslq`用户
: 2. 解压安装包到`/usr/loca/`
: 3. 创建软连接`ln -sv /usr/local/mariadb-VERSION-linux-x86_64 /usr/loca/mysql`
: 4. 将`/usr/local/mysql`所有的文件属主更改为root
: 5. 拷贝`/usr/local/mysql/support-files/my-huge.cnf` 并重命名为`/etc/my.cnf`
: 6. 修改配置文件`/etc/my.cnf`
: 7. 添加PATH环境变量`PATH=/usr/local/mysql/bin:$PATH`
: 8. 进入`/usr/local/mysql`文件夹并安装mysql启动初始化需要的数据库
: 9. 拷贝启动文件，并添加开机启动

**注意**:在centos8中，需要安装`ncurses-compat-libs.x86_64`其提供`libncurses.so.5`动态库

- 主机A上的具体安装过程

```bash
[root@localhost ~]# useradd -r -s /sbin/nologin mysql 
[root@localhost ~]# tar xvf mariadb-10.2.27-linux-x86_64.tar.gz -C /usr/local
[root@localhost ~]# cd /usr/local
[root@localhost /usr/local]# ls -sv mariadb-10.2.27-linux-x86_64 mysql 
[root@localhost /usr/local/mysql]# cd mysql
[root@localhost /usr/local/mysql]# chown -R root.root ./* 
[root@localhost ~]# mkdir /data/mysql -p
[root@localhost ~]# chown -R mysql.mysql /data/mysql
[root@localhost ~]# cp support-files/my-huge.cnf /etc/my.cnf 
[root@localhost ~]# cd 
[root@localhost ~]# vim /etc/my.cnf 
[mysqld]
datadir =/data/mysql
skip_name_resolve = ON 

[root@localhost ~]#vim /etc/profile.d/lamp.sh
PATH=/usr/local/mysql/bin/:$PATH
.  /etc/profile.d/lamp.sh
[root@localhost ~]# cd /usr/local/mysql
[root@localhost /usr/local/mysql]# scripts/mysql_install_db  --user=mysql --datadir=/data/mysql
[root@localhost /usr/local/mysql]# cp support-files/mysql.server  /etc/rc.d/init.d/mysqld
[root@localhost ~]# chkconfig --add mysqld
[root@localhost ~]# service mysqld start

# 为wordpress准备数据库和用户信息
mysql
mysql> create database wordpress;
mysql> grant all on wordpress.* to wpuser@'192.168.8.%' identified by "wppass";
mysql> grant all on discuz.* to discuz@'192.168.8.%' identified by 'dispass';
```

## 1.2 编译安装 HTTPD-2.4.41

编译安装HTTPD的一般步骤：
: 创建`-apache`用户
: 安装依赖`yum install gcc pcre-devel openssl-devel expat-devel -y`
: 解压`apr`和`apr-util`并移动到解压了的httpd目录下的`srclib`文件夹
: 进入httpd的解压目录运行configure脚本生成Makefile文件
: 使用make工具编译
: 添加PATH，如`PATH=/app/httpd24/bin:$PATH`
: 修改配置文件

- 主机B上的具体编译安装过程

```bash

[root@localhost data]# ll httpd-2.4.41/srclib/
total 16
drwxr-xr-x 28 1001 1001 4096 Dec 15 18:56 apr
drwxr-xr-x 21 1001 1001 4096 Dec 15 18:56 apr-util

[root@localhost data]# cd httpd-2.4.41/
[root@localhost /data/httpd-2.4.41]# cd httpd-2.4.41/

[root@localhost /data/httpd-2.4.41]# ./configure --prefix=/app/httpd24 \
    --enable-so \
    --enable-ssl \
    --enable-cgi \
    --enable-rewrite \
    --with-zlib \
    --with-pcre  \
    --enable-modules=most  \
    --enable-mpms-shared=all \
    --with-mpm=prefork  \
    --with-included-apr
 
[root@localhost /data/httpd-2.4.41]# make -j 6 && make install

[root@localhost ~]# vim /etc/profile.d/lamp.sh
PATH=/app/httpd24/bin:$PATH

[root@localhost ~]# . /etc/profile.d/lamp.sh


[root@localhost ~]# vim /etc/httpd24/conf/httpd
user apache
group apache


[root@localhost ~]# apachectl

```

## 1.3 编译安装 FastCGI 协议的 php-7.3


编译安装PHP的一般步骤：
: 安装相关的依赖包，注意：php不同版本需要的依赖不一样
: 解压进到解压的包文件夹
: 运行configure脚本生成Makefile文件
: 使用make工具编译，注意：php不同的版本编译选项不一样

- PHP在主机B上的具体编译安装过程

```bash
# 安装相关的依赖包
# php 7.3 相关包
yum install gcc libxml2-devel bzip2-devel libmcrypt-devel 
# php 7.4 相关包
yum install gcc libxml2-devel bzip2-devel libmcrypt-devel sqlite-devel oniguruma-devel

# 编译安装php7.3
tar xvf php-7.3.10.tar.bz2
cd php-7.3.10
./configure --prefix=/app/php73 \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-openssl \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--with-config-file-path=/etc \
--with-config-file-scan-dir=/etc/php.d \
--enable-mbstring \
--enable-xml \
--enable-sockets \
--enable-fpm \
--enable-maintainer-zts \
--disable-fileinfo

# php7.4 编译选项
tar xvf php-7.4.0.tar.xz 
cd php-7.4.0/
./configure \
--prefix=/app/php74 \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-openssl    \
--with-zlib  \
--with-config-file-path=/etc \
--with-config-file-scan-dir=/etc/php.d \
--enable-mbstring \
--enable-xml \
--enable-sockets 
--enable-fpm \
--enable-maintainer-zts \
--disable-fileinfo


make -j 4 && make install


# 查看版本，确认是否安装成功
/app/php73/bin/php --version

# 准备php配置文件和启动文件
cp /data/php-7.3.12/php.ini-production  /etc/php.ini
cp /data/php-7.3.12/aspi/fpm/php-fpm.service /usr/lib/systemd/system
cp /app/php73/etc/php-fpm.default /app/php/73/etc/php-fpm.conf
cp /app/php73/etc/php-fpm.d/www.conf.default  /app/php73/etc/php-fpm.d/www.conf

# 修改进程所有者
vim /app/php73/etc/php-fpm.d/www.conf
user apache
group apache

# 支持status和ping页面
vim www.conf
pm.status_path = /status
ping.path = /ping  

# 支持opcache加速
mkdir /etc/php.d/
vim /etc/php.d/opcache.ini
[opcache]
zend_extension=opcache.so
opcache.enable=1

systemctl daemon-reload
systemctl status php-fpm.service 
systemctl enable --now  php-fpm.service 

```

## 1.4 修改配置httpd 支持php-fpm

```bash
vim /app/httpd24/conf/httpd.conf
# 取消下面两行的注释
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
# 修改下面行
<IfModule dir_module>
DirectoryIndex index.php index.html
</IfModule>
# 加下面三行
AddType application/x-httpd-php .php
AddType application/x-httpd-php-source .phps
ProxyRequests Off
# 实现两个虚拟主机
<virtualhost *:80>
servername wordpress.suosuoli.cn
documentroot /data/wordpress
<directory /data/wordpress>
require all granted
</directory>
ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/data/wordpress/$1
# 实现status和ping页面
ProxyPassMatch ^/(status|ping)$ fcgi://127.0.0.1:9000/$1 
CustomLog "logs/access_wordpress_log" common
</virtualhost>
<virtualhost *:80>
servername discuz.suosuoli.cn
documentroot /data/discuz
<directory /data/discuz/>
require all granted
</directory>
ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/data/discuz/$1
CustomLog "logs/access_discuz_log" common
</virtualhost> 
apachectl restart
```

## 1.5 部署 wordpress

```bash
# 准备wordpress程序文件
mkdir  /data/
tar xvf  wordpress-5.3-zh_CN.tar.gz
mv wordpress/ /data
# 设置权限
setfacl –R –m u:apache:rwx /data/wordpress/
# 或者chown –R apache.apache /data/wordpress

# 修改hosts文件
vim /etc/hosts
172.20.1.191  wordpress.suosuoli.cn discuz.suosuoli.cn
```

- 修改windows下的hosts文件`c:\windows\system32\drivers\etc\hosts`

- 浏览器测试访问`http://wordpress.suosuoli.cn`

## 1.5 部署 Discuz

```bash
# 准备discuz!程序文件
unzip Discuz_X3.4_SC_UTF8【20190917】.zip 
mkdir /data/discuz
mv upload/* /data/discuz
# 设置权限
setfacl -R -m u:apache:rwx /data/discuz/
```

- 修改windows下的hosts文件`c:\windows\system32\drivers\etc\hosts`

- 浏览器测试访问`http://discuz.suosuoli.cn`

## 1.6 修改为UDS模式(UNIX Domain Socket)

- php-fpm服务可以监听TCP套接字(TCP socket)或者域套接字(unix domain socket)，
监听TCP套接字表示FastCGI请求来自于远程服务器，监听与套接字表示FastCGI请求来自
本地的httpd服务。

- 配置具体过程

```bash
vim /app/php/etc/php-fpm.d/www.conf
;listen = 127.0.0.1:9000
listen = /run/php-fpm.sock
listen.owner = apache
listen.group = apache
listen.mode = 0660
systemctl restart php-fpm
ll /run/php-fpm.sock 
srw-rw---- 1 apache apache 0 Dec 14 11:11 /run/php-fpm.sock
vim /app/httpd24/conf/httpd.conf
<virtualhost *:80>
servername wordpress.suosuli.cn
documentroot /data/wordpress
<directory /data/wordpress>
require all granted
</directory>
#ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/data/wordpress/$1
ProxyPassMatch ^/(.*\.php)$ "unix:/run/php-
fpm.sock|fcgi://localhost/data/wordpress/"
#ProxyPassMatch ^/(status|ping)$ fcgi://127.0.0.1:9000/$1
ProxyPassMatch ^/(status|ping)$ "unix:/run/php-fpm.sock|fcgi://localhost/"    
CustomLog "logs/access_wordpress_log" common
</virtualhost>
<virtualhost *:80>
servername wordpress.suosuli.cn
documentroot /data/wordpress
<directory /data/wordpress>
require all granted
</directory>
#ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/data/discuz/$1
ProxyPassMatch ^/(.*\.php)$ "unix:/run/php-
fpm.sock|fcgi://localhost/data/discuz/"
#ProxyPassMatch ^/(status|ping)$ fcgi://127.0.0.1:9000/$1
ProxyPassMatch ^/(status|ping)$ "unix:/run/php-fpm.sock|fcgi://localhost/"    
CustomLog "logs/access_wordpress_log" common
</virtualhost>
apachectl restart
```