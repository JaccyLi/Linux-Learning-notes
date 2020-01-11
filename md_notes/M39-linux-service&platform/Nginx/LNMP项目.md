LNMP 项目 WordPress 站点搭建

# 一.部署数据库

## 1.1 二进制部署 MySQL

```bash
# 安装依赖
[root@s2 ~]# yum install vim gcc gcc-c++ wget autoconf  net-tools lrzsz iotop lsof iotop bash-completion  curl policycoreutils openssh-server openssh-clients postfix -y
# 准备二进制包
[root@s2 ~]# cd /usr/local/src/
[root@s2 src]# tar xf mysql-5.6.43-linux-glibc2.12-x86_64.tar.gz
[root@s2 src]# tar xf mysql-5.6.43-linux-glibc2.12-x86_64.tar.gz
# 创建软连接
[root@s2 src]# ln -sv /usr/local/src/mysql-5.6.43-linux-glibc2.12-x86_64  /usr/local/mysql
‘/usr/local/mysql’ -> ‘/usr/local/src/mysql-5.6.43-linux-glibc2.12-x86_64’
# 创建mysql用户
[root@s2 mysql]# useradd  mysql -s /sbin/nologin
[root@s2 mysql]# mkdir -pv /data/mysql /var/lib/mysql
# 数据目录权限授权给mysql用户
[root@s2 mysql]# chown  -R mysql.mysql  /data   /var/lib/mysql -R
# 安装初始化数据库
[root@s2 mysql]# /usr/local/mysql/scripts/mysql_install_db --user=mysql --datadir=/data/mysql --basedir=/usr/local/mysql
# 准备启动文件
[root@s2 mysql]# cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
[root@s2 mysql]#  chmod a+x /etc/init.d/mysqld
# 准备配置文件
[root@s2 mysql]# vim /etc/my.cnf
[mysqld]
socket=/data/mysql/mysql.sock
user=mysql
symbolic-links=0
datadir=/data/mysql
innodb_file_per_table=1
max_connections=10000

[client]
port=3306
socket=/var/lib/mysql/mysql.sock

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/tmp/mysql.sock
```

## 1.2 创建数据库和用户并授权

```bash
# 使用启动文件启动数据库
[root@s2 ~]# /etc/init.d/mysqld  start
[root@s2 ~]# ln -sv /data/mysql/mysql.sock /var/lib/mysql/mysql.sock
[root@s2 ~]# /usr/local/mysql/bin/mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.6.43 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# 创建wordpress数据库
mysql> CREATE DATABASE wordpress;
Query OK, 1 row affected (0.00 sec)

# 创建用户并授权
mysql> GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress"@"192.168.7.%"  IDENTIFIED BY
"123456";
Query OK, 0 rows affected (0.00 sec)

# 刷新权限
mysql>  FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

mysql>  FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
| wordpress          |
+--------------------+
5 rows in set (0.00 sec)
```

## 1.3 验证账户访问权限

在 WordPress 服务器使用授权的 MySQL 账户远程登录测试权限

```bash
[root@s1 etc]# mysql -uwordpress -h192.168.7.102 -p123456
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.6.43 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| test               |
| wordpress          |
+--------------------+
3 rows in set (0.00 sec)
```

# 二.部署 PHP

## 2.1 编译安装 PHP 7.2.15

```bash
# 安装依赖
[root@s1 ~]# yum -y install wget vim pcre pcre-devel openssl openssl-devel libicu-devel
gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel
libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel ncurses
ncurses-devel curl curl-devel krb5-devel libidn libidn-devel openldap openldap-devel
nss_ldap jemalloc-devel cmake boost-devel bison automake libevent libevent-devel gd gd-
devel libtool* libmcrypt libmcrypt-devel mcrypt mhash libxslt libxslt-devel readline
readline-devel gmp gmp-devel libcurl libcurl-devel openjpeg-devel

[root@s1 src]# pwd
/usr/local/src
# 准备源码
[root@s1 src]# tar xf php-7.2.15.tar.gz
[root@s1 src]# cd php-7.2.15
# 生成Makefile文件
[root@s1 php-7.2.15]# ./configure  --prefix=/apps/php --enable-fpm --with-fpm-user=www -
-with-fpm-group=www --with-pear --with-curl  --with-png-dir --with-freetype-dir --with-
iconv   --with-mhash   --with-zlib --with-xmlrpc --with-xsl --with-openssl  --with-
mysqli --with-pdo-mysql --disable-debug --enable-zip --enable-sockets --enable-soap   --
enable-inline-optimization  --enable-xml --enable-ftp --enable-exif --enable-wddx --
enable-bcmath --enable-calendar   --enable-shmop --enable-dba --enable-sysvsem --enable-
sysvshm --enable-sysvmsg
# 使用4个核心编译
[root@s1 php-7.2.15]# make -j 4
# 安装
[root@s1 php-7.2.15]# make  install
```

## 2.2 准备 PHP 配置文件

```bash
# 注意区分配置文件所在的位置
[root@s1 php-7.2.15]# cd /apps/php/etc/php-fpm.d/
[root@s1 php-fpm.d]# cp www.conf.default  www.conf
[root@s1 php-fpm.d]# cp /usr/local/src/php-7.2.15/php.ini-production
/apps/php/etc/php.ini
[root@s1 php-fpm.d]# useradd  www -s /sbin/nologin  -u 1001
[root@s1 php-fpm.d]# grep -v ";" www.conf | grep -v "^$"
[www]
user = www
group = www
listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1
pm = dynamic
pm.max_children = 50
pm.start_servers = 30
pm.min_spare_servers = 30
pm.max_spare_servers = 35
pm.status_path = /pm_status
ping.path = /ping
ping.response = pong
access.log = log/$pool.access.log
slowlog = log/$pool.log.slow

[root@s1 etc]# mkdir /apps/php/log/  #日志文件路径
[root@s1 etc]# cd /apps/php/etc/
[root@s1 etc]# cp php-fpm.conf.default  php-fpm.conf
```

## 2.3 启动 php-fpm 服务

```bash
# 检测语法并启动php-fpm：
[root@s1 etc]# /apps/php/sbin/php-fpm  -t
[06-Mar-2019 18:44:46] NOTICE: configuration file /apps/php/etc/php-fpm.conf test is
successful

# 验证php-fpm：
[root@s1 etc]# /apps/php/sbin/php-fpm  -c /apps/php/etc/php.ini
[root@s1 etc]# ps -ef | grep php-fpm
root     115708      1  0 18:45 ?        00:00:00 php-fpm: master process
(/apps/php/etc/php-fpm.conf)
www      115709 115708  0 18:45 ?        00:00:00 php-fpm: pool www
www      115710 115708  0 18:45 ?        00:00:00 php-fpm: pool www

[root@s1 etc]# netstat  -tanlp | grep php-fpm
tcp      0   0 127.0.0.1:9000     0.0.0.0:*   LISTEN    115708/php-fpm: mas
```

# 三.部署 Nginx

## 3.1 下载 nginx

```bash
# 安装依赖
[root@s1 ~]# yum install -y vim lrzsz tree screen psmisc lsof tcpdump wget  ntpdate  gcc
gcc-c++ glibc glibc-devel pcre pcre-devel openssl  openssl-devel systemd-devel net-tools
iotop bc  zip unzip zlib-devel bash-completion nfs-utils automake libxml2  libxml2-devel
libxslt libxslt-devel perl perl-ExtUtils-Embed
[root@s1 ~]# cd /usr/local/src/

# 下载源码
[root@s1 src]# wget https://nginx.org/download/nginx-1.12.2.tar.gz
[root@s1 src]# tar xf nginx-1.12.2.tar.gz
[root@s1 src]# cd nginx-1.12.2
```

## 3.2 修改源码 server 信息

自定义 Response Hearders 中 server 信息

```bash
[root@s1 nginx-1.12.2]# vim src/core/nginx.h
 13 #define NGINX_VERSION      "1.2"
 14 #define NGINX_VER          "stevenux/" NGINX_VERSION #开启server_tokens显示此信息

[root@s1 nginx-1.12.2]# vim src/http/ngx_http_header_filter_module.c
49 static u_char ngx_http_server_string[] = "Server: stevenux-engine" CRLF; # 关闭server_tokens显示此信息
```

## 3.3 编译安装

```bash
# 生成Makefile文件
[root@s1 nginx-1.12.2]# ./configure --prefix=/apps/nginx \
> --user=www  \
> --group=www \
> --with-http_ssl_module \
> --with-http_v2_module \
> --with-http_realip_module \
> --with-http_stub_status_module  \
> --with-http_gzip_static_module \
> --with-pcre \
> --with-stream \
> --with-stream_ssl_module \
> --with-stream_realip_module
# 编译
[root@s1 nginx-1.12.2]# make
# 安装
[root@s1 nginx-1.12.2]# make install
```

## 3.4 准备 php 测试页面

```bash
[root@s1 ~]# mkdir /data/nginx/wordpress -p
[root@s1 ~]# vim /data/nginx/wordpress/index.php
<?php
  phpinfo();
?>
```

## 3.5 配置 Nginx

```bash
[root@s1 ~]# grep -v "#" /apps/nginx/conf/nginx.conf | grep -v "^$"
    server {
        listen       80;
        server_name  www.suosuoli.cn;
        location / {
            root   /data/nginx/wordpress;
            index   index.php index.html index.htm;
        if ($http_user_agent ~ "ApacheBench|WebBench|TurnitinBot|Sogou web spider|Grid
Service") {
         return 403;
       }
     }
         location ~ \.php$ {
           root          /data/nginx/wordpress;
           fastcgi_pass   127.0.0.1:9000;
           fastcgi_index  index.php;
           fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
           include        fastcgi_params;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
```

## 3.6 重启访问 php 状态页

```bash
[root@s1 ~]# /apps/nginx/sbin/nginx -t
nginx: the configuration file /apps/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /apps/nginx/conf/nginx.conf test is successful
[root@s1 ~]# /apps/nginx/sbin/nginx -s reload
```

# 四.部署 Wordpress

## 4.1 部署 Wordpress

```bash
# 移走测试页面
[root@s1 ~]# cd /data/nginx/wordpress/
[root@s1 wordpress]# mv index.php  /opt/
# 准备wordpress程序包
[root@s1 wordpress]# unzip wordpress-5.0.3-zh_CN.zip
[root@s1 wordpress]# mv wordpress/* .
[root@s1 wordpress]# mv wordpress wordpress-5.0.3-zh_CN.zip  /opt/
[root@s1 wordpress]# cp wp-config-sample.php  wp-config.php
# 填写配置文件，数据库信息
[root@s1 wordpress]# vim wp-config.php
// ** MySQL 设置 - 具体信息来自您正在使用的主机 ** //
/** WordPress数据库的名称 */
define('DB_NAME', 'wordpress');

/** MySQL数据库用户名 */
define('DB_USER', 'wordpress');

/** MySQL数据库密码 */
define('DB_PASSWORD', 'stevenux');

/** MySQL主机 */
define('DB_HOST', '172.20.2.2');

[root@s1 wordpress]# chown  www.www /data/nginx/wordpress/ /apps/nginx/ -R
[root@s1 wordpress]# /apps/nginx/sbin/nginx  -s reload
```

## 4.2 初始化配置

访问`http://www.suosuoli.cn/index.php`初始化

## 4.3 验证数据库

```bash
# 初始化wordpress生成的表
mysql> use wordpress;
Database changed
mysql> show tables;
+-----------------------+
| Tables_in_wordpress   |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
12 rows in set (0.00 sec)
```

## 4.4 验证自定义的 server 信息

在浏览器的调试窗口查看`Server:xxx`字段
为：`Server:stevenux-engine`

## 4.5 隐藏 PHP 版本

```bash
[root@s1 nginx-1.12.2]# vim /apps/nginx/conf/nginx.conf
location ~ \.php$ {
   root          /data/nginx/wordpress;
   fastcgi_pass   127.0.0.1:9000;
   fastcgi_index  index.php;
   fastcgi_hide_header X-Powered-By;
   fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
   include        fastcgi_params;
}
# 重启nginx并验证是否隐藏PHP版本：
[root@s1 nginx-1.12.2]# /apps/nginx/sbin/nginx -t
nginx: the configuration file /apps/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /apps/nginx/conf/nginx.conf test is successful
[root@s1 nginx-1.12.2]# /apps/nginx/sbin/nginx -s reload
```

# 五.使用 PHP 扩展 session 模块--redis

## 5.1 编译安装 php-pecl-redis

```bash
[root@s1 ~]# yum install php-pecl-redis
[root@s1 ~]# cd /usr/local/src/
[root@s1 src]# tar xf phpredis-4.2.0.tar.gz
[root@s1 src]# cd phpredis-4.2.0

# 生成配置文件
[root@s1 phpredis-4.2.0]# ll | wc -l
37
[root@s1 phpredis-4.2.0]# /apps/php/bin/phpize
Configuring for:
PHP Api Version:         20170718
Zend Module Api No:      20170718
Zend Extension Api No:   320170718
[root@s1 phpredis-4.2.0]# ll | wc -l
52

# 编译安装
[root@s1 phpredis-4.2.0]# ./configure  --with-php-config=/apps/php/bin/php-config
reating libtool
    appending configuration tag "CXX" to libtool
    configure: creating ./config.status
    config.status: creating config.h
    [root@s1 phpredis-4.2.0]#
[root@s1 phpredis-4.2.0]# make && make install
    Build complete.
    Dont forget to run "make test".
    Installing shared extensions:     /apps/php/lib/php/extensions/no-debug-non-zts-
20170718/

# 验证redis模块
[root@s1 phpredis-4.2.0]# ll /apps/php/lib/php/extensions/no-debug-non-zts-20170718/
total 7372
-rwxr-xr-x 1 www  www  3586572 Mar  6 18:28 opcache.a
-rwxr-xr-x 1 www  www  1974184 Mar  6 18:28 opcache.so
-rwxr-xr-x 1 root root 1984768 Mar  7 10:54 redis.so

# 编辑php.ini配置文件，扩展redis.so模块
[root@s1 phpredis-4.2.0]# vim /apps/php/etc/php.ini
1928 extension=/apps/php/lib/php/extensions/no-debug-non-zts-20170718/redis.so

# 重启php-fpm：
[root@s1 phpredis-4.2.0]# pkill  php-fpm
[root@s1 phpredis-4.2.0]# /apps/php/sbin/php-fpm  -t
[07-Mar-2019 11:10:08] NOTICE: configuration file /apps/php/etc/php-fpm.conf test is
successful
[root@s1 phpredis-4.2.0]# /apps/php/sbin/php-fpm  -c /apps/php/etc/php.ini

# 通过pid文件操作php-fpm，前提是配置了php-fpm文件路径
[root@s1 phpredis-4.2.0]# kill -INT  `cat /apps/php/var/run/php-fpm.pid`
[root@s1 phpredis-4.2.0]# kill -USR2 `cat /apps/php/var/run/php-fpm.pid`
```

## 5.2 验证加载 redis 模块

准备状态页

```bash
[root@s1 phpredis-4.2.0]# cat /data/nginx/wordpress/php-status.php
<?php
  phpinfo();
?>
```

访问`http://www.suosuoli.cn/php-status.php`验证

## 5.3 将 session 写入 redis

```bash
[root@s1 phpredis-4.2.0]# yum install redis
[root@s1 phpredis-4.2.0]# systemctl  start redis
[root@s1 phpredis-4.2.0]# systemctl  enable  redis
```

## 5.4 配置 php.ini

```bash
1328 [Session]
1331 session.save_handler = redis
1399 session.save_path = "tcp://127.0.0.1:6379"
1400 ;session.save_path = "tcp://IP:6379？auth=PASSWORD"

# 重启php-fpm
[root@s1 phpredis-4.2.0]# /apps/php/sbin/php-fpm  -t
[root@s1 phpredis-4.2.0]# kill -USR2 `cat /apps/php/var/run/php-fpm.pid`
```

## 5.5 准备 session 写入 web 页面

```bash
[root@s1 php-fpm.d]# cat /data/nginx/wordpress/session.php
<?php
echo "test session page?";
session_start();
$_SESSION['a'] = 'stevenux test php write session to redis';
?>
```

访问`http://www.suosuoli.cn/session.php`验证

## 5.6 redis 验证 session 数据

```bash
[root@s1 phpredis-4.2.0]# redis-cli
127.0.0.1:6379> KEYS *
1) "PHPREDIS_SESSION:q12hvhqocuh7g3o4sr7o490i18"
127.0.0.1:6379> get PHPREDIS_SESSION:q12hvhqocuh7g3o4sr7o490i18
"a|s:38:\"stevenux test php write session to redis\";"
127.0.0.1:6379>
```
