<center><font face="黑体" color="grey" size="5">LAMP(3)_PHP优化</font></center>

# 一.常见的第三方PHP优化插件

## 1.1 APC(Alternative PHP Cache)

遵循PHP License的开源框架，PHP opcode缓存加速器，目前的版本不适用于PHP 5.4
[项目地址](http://pecl.php.net/package/APC)

## 1.2 eAccelerator

源于Turck MMCache，早期的版本包含了一个PHP encoder和PHP loader，目前encoder
已经不再支持。
[项目地址](http://eaccelerator.net/)

## 1.3 XCache

快速而且稳定的PHP opcode缓存，经过严格测试且被大量用于生产环境。
[项目地址](http://xcache.lighttpd.net/)收录于EPEL源

## 1.4 Zend Optimizer和Zend Guard Loader

Zend Optimizer并非一个opcode加速器，它是由Zend Technologies为PHP5.2及以前的版
本提供的一个免费、闭源的PHP扩展，其能够运行由Zend Guard生成的加密的PHP代码或模
糊代码。 而Zend Guard Loader则是专为PHP5.3提供的类似于Zend Optimizer功能的扩
展。
[项目地址](http://www.zend.com/en/products/guard/runtime-decoders)

## 1.5 NuSphere PhpExpress

NuSphere的一款开源PHP加速器，它支持装载通过NuSphere PHP Encoder编码的PHP程序
文件，并能够实现对常规PHP文件的执行加速。
[项目地址](http://www.nusphere.com/products/phpexpress.htm)

# 二. 实现XCache优化加速PHP 5.X

- 环境:Centos7 EPEL源 PHP5.6

- 步骤

```bash
[root@centos7 ~]#yum -y install https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm
[root@centos7 ~]#yum install php56-php php56-php-mysqlnd mariadb-server
[root@centos7 ~]#systemctl enable --now httpd mariadb
Created symlink from /etc/systemd/system/multi-user.target.wants/httpd.service to /usr/lib/systemd/system/httpd.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/mariadb.service to /usr/lib/systemd/system/mariadb.service.
[root@centos7 ~]#mysql
MariaDB [(none)]> CREATE DATABASE wordpress;
MariaDB [(none)]> GRANT ALL ON wordpress.* TO wordpress@'localhost' IDENTIFIED BY 'stevenux';
[root@centos7 ~]#tar xvf wordpress-5.2.4-zh_CN.tar.gz  -C /var/www/html
[root@centos7 ~]#cd /var/www/html
[root@centos7 ~]#chown -R apache.apache wordpress/
[root@centos7 ~]#yum -y install gcc php-devel

# 下载并解压缩xcache-3.2.0.tar.bz2
[root@centos7 ~]#tar xf xcache-3.2.0.tar.gz

# 生成编译环境
[root@centos7 ~]#cd xcache-3.2.0/
[root@centos7 xcache-3.2.0]#/opt/remi/php56/root/usr/bin/phpize
Configuring for:
PHP Api Version:         20131106
Zend Module Api No:      20131226
Zend Extension Api No:   220131226

# 编译
[root@centos7 xcache-3.2.0]#./configure --enable-xcache --with-php-config=/opt/remi/php56/root/usr/bin/php-config
[root@centos7 xcache-3.2.0]#make && make install
...
Installing shared extensions:     /opt/remi/php56/root/usr/lib64/php/modules/
[root@centos7 xcache-3.2.0]#cat xcache.ini  >> /opt/remi/php56/root/etc/php.ini

# 安装base源中执行即可cp xcache.ini  /etc/php.d/
[root@centos7 ~]#systemctl restart httpd.service

# 测试性能
[root@centos7 ~]#ab -c10 -n 100 http://LAMP_server_ip/wordpress
```

# 三.实现Opcache加速PHP 7.X

- 一般步骤

```bash
# 下载
[root@centos8 ~]#dnf install php-opcache

# 编辑配置文件
[root@centos8 ~]#cat  /etc/php.ini
[opcache]
zend_extension=opcache.so
opcache.enable=1
```
- Centos8安装opcache
```bash
[root@centos8 ~]#dnf install php-opcache
[root@centos8 ~]#rpm -ql php-opcache
/etc/php.d/10-opcache.ini
/etc/php.d/opcache-default.blacklist
/usr/lib/.build-id
/usr/lib/.build-id/71
/usr/lib/.build-id/71/55ebb00f7ebcab9d708c1d5c7b7e634cce259c
/usr/lib64/php/modules/opcache.so
[root@centos8 ~]#grep opcache /etc/php.d/10-opcache.ini
zend_extension=opcache
opcache.enable=1
...
```