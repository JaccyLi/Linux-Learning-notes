<center><font face="幼圆" size="5" color="grey">mysql各种安装姿势解锁</center></font>

# 一.二进制包安装mysql

## 1.mysql二进制包介绍

### 1.1 二进制包获取途径

- 1.[mysql官网](https://dev.mysql.com)
- 2.[mariadb官网](https://mariadb.org)

```sh
https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/mysql-5.7.26-el7-x86_64.tar.gz
https://downloads.mariadb.org/interstitial/mariadb-10.2.29/bintar-linux-x86_64/mariadb-10.2.29-linux-x86_64.tar.gz/from/http%3A//mirrors.tuna.tsinghua.edu.cn/mariadb/
```

### 1.2 包名指明了安装包的类型(二进制包|源码包|rpm包|deb包)

|包名|说明|
|---|---|
|mariadb-10.2.29.tar.gz|未指明平台和安装包后缀rpm或者deb，为源码包，用于编译安装|
|mariadb-10.2.29-linux-x86_64.tar.gz|指明了已经为linux平台编译，为通用二进制程序包(centos6-8)|
|mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz|指明为linux平台编译好的二进制包,也指明安装时依赖glibc2.12库，没有该库需要手动安装该库|
|mariadb-10.2.29-linux-systemd-x86_64.tar.gz|适用于dentos7及以上的二进制包，依赖于systemd服务来管理|

## 2.安装mysql二进制包的一般步骤

### 2.1 准备用户

```bash
groupadd -r -g GNUM mysql
useradd -r -g GNUM -d /data/mysql mysql
```

### 2.2 准备数据目录

- 使用LV

```bash
1.创建LV
df -Th
fdisk /dev/sdb
pvcreate /dev/sdb3
vgcreate vg_mysql /dev/sdb3
lvcreate -l 100%free -n mysql vg_mysql
2.使之开机挂载
mkdir /data/mysql -p
vim /etc/fstab
...
/dev/vg_mysql/mysql /data/mysql ext4  defaults 0 0
...
3.更改属主
chown mysql:mysql /data/mysql
```

- 不使用LV

```bash
mkdir /data/mysql -p
chown mysql:mysql /data/mysql
```

### 2.3 准备二进制程序

```sh
tar -zxf mysql-VERSION-linux-[deps-]x86_64.tar.gz -C /usr/local  # 源码文件解压至/usr/local/src
cd /usr/local
ln -sv mysql-VERSION-linux-[deps-]x86_64 mysql
chown -R root:mysql /usr/local/mysql
```

### 2.4 准备配置文件

```sh
mkdir /etc/mysql
cdp /usr/local/mysql/support-files/my-large.cnf /etc/mysql/my.cnf
vim /etc/mysql/my.cnf
...
[mysqld]
datadir = /data/mysql
innodb_file_per_table = on
skip_name_resolve = on
...
```

### 2.5 创建数据库文件

```sh
mysql 5.7
/usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/data/mysql

mysql 其它版
cd /usr/local/mysql
./scripts/mysql_install_db --datadir=/data/mysql --user=mysql
```

### 2.6 准备服务脚本

```sh
cd /usr/local/mysql
cp ./support-files/mysql.server /etc/rc.d/ini.d/mysqld # centos6
chkconfig --add mysqld  # centos6
service mysqld start  # centos6

cp ./support-files/systemd/mariadb.service /usr/lib/systemd/system/  # centos7|8
systemctl daemon-reload
systemctl enable --now mariadb
```

### 2.7 配置PATH路径

```sh
echo 'PATH=/usr/local/mysql/bin:$PATH' > /etc/profile.d/mysql.sh
. /etc/profile.d/mysql.sh
```

### 2.8 安全初始化

```sh
/usr/local/mysql/bin/mysql_secur_installation
```

## 3.Trouble shooting

- 无法启动服务？
  - /etc/my.cnf 配置文件有错误
  - /data/mysql 文件夹未成功生成数据库文件
- 使用service或者systemctl命令启动时提示未找到命令？
  - PATH环境变量设置有误或者没有启用(. /etc/profile.d/mysql.sh)

# 二.源码编译安装MariaDB

## 1.概述

- mariadb使用cmake编译工具编译安装,而不用传统的make工具。cmake的重要特性之一是其可以独立
于源码(out-of-source)编译，也即编译工作可以在另一个指定的目录中而不用像make一定到进到源码
目录中进行编译，这可以保证源码目录不受任何一次编译的影响，因此在同一个源码树上可以进行多次
不同的编译
- 详细的编译选项见[mysql官网表格](https://dev.mysql.com/doc/refman/5.7/en/source-configuration-options.html)

## 2.具体编译安装步骤

### 2.1 安装相关的依赖包

```sh
yum install bison bison-devel zlib-devel libcurl-devel libarchive-devel boostdevel
gcc gcc-c++ cmake ncurses-devel gnutls-devel libxml2-devel openssldevel
libevent-devel libaio-devel
```

### 2.2 准备用户

```sh
useradd -r -s /sbin/nologin -d /data/mysql/ mysql
```

### 2.3 准备数据目录

```sh
mkdir /data/mysql -p
chown mysql:mysql /data/mysql
```

### 2.4 下载并解压源码包

```sh
wget https://downloads.mariadb.org/interstitial/mariadb-10.2.29/bintar-linux-x86_64/mariadb-10.2.29-linux-x86_64.tar.gz/from/http%3A//mirrors.tuna.tsinghua.edu.cn/mariadb/
tar -zxf mariadb-10.2.29-linux-x86_64.tar.gz -C /usr/local/
```

### 2.5 选取合适参数cmake编译

```sh
cd /usr/local/mariadb-10.2.29/
cd mariadb-10.2.18/
cmake . \
-DCMAKE_INSTALL_PREFIX=/app/mysql \
-DMYSQL_DATADIR=/data/mysql/ \
-DSYSCONFDIR=/etc/ \
-DMYSQL_USER=mysql \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITHOUT_MROONGA_STORAGE_ENGINE=1 \
-DWITH_DEBUG=0 \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DWITH_LIBWRAP=0 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_UNIX_ADDR=/data/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
```

- 编译出错，可以执行下面命令后重试:
`rm -f CMakeCache.txt`

### 2.6 配置环境变量

```sh
echo 'PATH=/app/mysql/bin:$PATH' > /etc/profile.d/mysql.sh
. /etc/profile.d/mysql.sh
```

### 2.7 生成数据库文件

```sh
cd /app/mysql
./scripts/mysql_install_db --datadir=/data/mysql --user=mysql
```

### 2.8 准备配置文件

```sh
cdp /app/mysql/support-files/my-huge.cnf /etc/my.cnf
```

### 2.9 准备启动脚本，启动服务

```sh
cd /app/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfgi -add mysql
service mysqld start
```

### 2.10 安全初始化

```sh
mysql_secure_installation
```

# 三.一键安装mysql二进制程序包脚本

```py
#!/bin/bash
#
#*******************************************************************************
#Author:			steveli
#QQ:				1049103823
#Data:			    2019-11-18
#FileName:		    auto_install_mysql_v00.sh
#URL:               http://suosuoli.cn
#URL:		        https://blog.csdn.net/YouOops
#Description:		A simple script to install binary code of mysql or to compile mysql and install.
#Copyright (C):	    2019 All rights reserved
#******************************************************************************
#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)#
#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)#
#******************************************************************************
#Update log:
#V00:install mysql5.6 mysql5.7 and mariadb10.2 on centos6
#V01:install mysql5.6 myaql5.7 and mariadb10.2 on centos6&centos7
#
#######################
declare -a MYSQL_VER
WORKING_DIR=`pwd`
DATA_DIR="/data/mysql"
BASE_DIR="/usr/local"
SYS_VER=`cat /etc/redhat-release | sed -nr 's/.* ([0-9]+)\.[0-9]+\.?.*/\1/p'`
BINARY_NAME=
MYSQL_VER=( mysql-5.6.46 mysql-5.7.26 mariadb-10.2.29 )
#######################


#######################
. /etc/init.d/functions
# success
# passed
# warning
# failure
#######################

_test() {
#echo ${MYSQL_VER[@]}
#echo ${MYSQL_VER[0]}
#echo ${MYSQL_VER[1]}
#echo ${MYSQL_VER[2]}
#printf "%-255s\n" ${MYSQL_VER[0]} ${MYSQL_VER[1]} ${MYSQL_VER[2]}
:
}

pre_install() {
    status=$(echo `getenforce`)
    if [[ "$status" == "enforcing" ]]; then
        sed -ir 's#SELINUX=enforcing#SELINUX=disabled#' /etc/sysconfig/selinux && echo "SElinux disabled."
    else
        echo "SElinux has been disabled.`success`"
    fi

    if [[ "$SYS_VER" -eq "6" ]]; then
        iptables -F 
    else
        systemctl stop firewalld
        systemctl disable firewalld
    fi
}


## cerate a system user for mysql.
user_add() {
    if id mysql &> /etc/null; then
        echo "User mysql exists.`passed`"
    else
        useradd -r mysql -s /sbin/nologin &> /etc/null
        echo "User mysql added.`success`"
    fi
}

determin_network(){
:
}

## install some dependencies and libs.
deps_install() {
    echo "Installing some deps and libs..."
    yum -y install bison bison-devel zlib-devel libcurl-devel libarchive-devel boost-devel gcc gcc-c++ cmake ncurses-devel gnutls-devel libxml2-devel openssl-devel libevent-devel libaio-devel &> /etc/null
    yum -y install wget vim curl irzsz lsof iotop net-tools perl perl-Data-Dumper libaio &> /etc/null
    echo "Deps and libs installed.`success`"
}

## not yet complete the code...
#lv_create() {
#    fdisk /dev/sdb
#    pvcreate /dev/sdb3
#    vgcreate vg_mysql /dev/sdb3
#    lvcreate -l 100%free -n mysql vg_mysql
#}

## $1=1-->5.6|2-->5.7|3-->10,2
get_binary_ready() {

    if [[ "$1" -eq "1" ]]; then
        if [[ -e ${WORKING_DIR}/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz ]]; then
            echo "Extracting \"mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz\"..."
            tar -zxf mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz -C ${BASE_DIR}
            echo "Done, all files alocated in ${BASE_DIR}/mysql-5.6.46-linux-glibc2.12-x86_64`success`"
        else
            wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
            #wget https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.46.tar.gz
            echo "Extracting \"mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz\"..."
            tar -zxf mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz -C ${BASE_DIR}
            echo "Done, all files alocated in ${BASE_DIR}/mysql-5.6.46-linux-glibc2.12-x86_64`success`"
        fi
        ln -s ${BASE_DIR}/mysql-5.6.46-linux-glibc2.12-x86_64 ${BASE_DIR}/mysql
        chown -R mysql:mysql ${BASE_DIR}/mysql
    elif [[ "$1" -eq "2" ]]; then
        if [[ -e ${WORKING_DIR}/mysql-5.7.26-el7-x86_64.tar.gz ]]; then
            echo "Extracting \"mysql-5.7.26-el7-x86_64.tar.gz\"..."
            tar -zxf mysql-5.7.26-el7-x86_64.tar.gz -C ${BASE_DIR}
            echo "Done, all files alocated in ${BASE_DIR}/mysql-5.7.26-el7-x86_64.tar.gz`success`"
        else
            #wget https://dev.mysql.com/get/Downloads/mysql-5.7.26-el7-x86_64.tar.gz
        wget https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/mysql-5.7.26-el7-x86_64.tar.gz
            echo "Extracting \"mysql-5.7.26-el7-x86_64.tar.gz\"..."
            tar -zxf mysql-5.7.26-el7-x86_64.tar.gz -C ${BASE_DIR}
            echo "Done, all files alocated in ${BASE_DIR}/mysql-5.7.26-el7-x86_64`success`"
        fi
        ln -s ${BASE_DIR}/mysql-5.7.26-el7-x86_64 ${BASE_DIR}/mysql
        chown -R mysql:mysql ${BASE_DIR}/mysql
    elif [[ "$1" -eq "3" ]]; then
        if [[ -e ${WORKING_DIR}/mariadb-10.2.29-linux-x86_64.tar.gz ]]; then
            echo "Extracting \"mariadb-10.2.29-linux-x86_64.tar.gz\"..."
            tar -zxf mariadb-10.2.29-linux-x86_64.tar.gz -C ${BASE_DIR}
            echo "Done, all files alocated in ${BASE_DIR}/mariadb-10.2.29-linux-x86_64.tar.gz`success`"
        else
            wget https://downloads.mariadb.org/interstitial/mariadb-10.2.29/bintar-linux-x86_64/mariadb-10.2.29-linux-x86_64.tar.gz/from/http%3A//mirrors.tuna.tsinghua.edu.cn/mariadb/
            echo "Extracting \"mariadb-10.2.29-linux-x86_64.tar.gz\"..."
            tar -zxf mariadb-10.2.29-linux-x86_64.tar.gz -C ${BASE_DIR}
            echo "Done, all files alocated in ${BASE_DIR}/mariadb-10.2.29-linux-x86_64`success`"
        fi
        ln -s ${BASE_DIR}/mariadb-10.2.29-linux-x86_64 ${BASE_DIR}/mysql
        chown -R mysql:mysql ${BASE_DIR}/mysql
    fi

}

## modify /etc/my.conf
configure_cnf() {
if [[ -e /etc/my.cnf ]]; then
    cp /etc/my.{cnf,cnf.backup}
fi
cat > /etc/my.cnf <<EOF
[mysqld]
datadir=/data/mysql
socket=/data/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mysql.log
pid-file=/var/run/mysql/mysql.pid
[client]
port=3306
socket=/data/mysql/mysql.sock
EOF
    echo "/etc/my.cnf configured.`success`"
}

path_ready() {
if [[ -e /etc/profile.d/mysql.sh ]]; then
    cp /etc/profile.d/mysql.{sh,sh.backup}
fi
cat > /etc/profile.d/mysql.sh <<EOF
export PATH=/usr/local/mysql/bin:\$PATH
EOF
    echo "PATH variable configured.`success`"
}

## grab the default passwd and change it for mysql 5.7  --> must run this after mysql started
change_default_passwd() {
    DEFAULT_PSWD=`sed -nr 's#.*\[Note\].*root@.*: (.*)#\1#p' /tmp/mysql5.7_databases_install.log`
    read -p "Please input the passwd you want to set:" SET_PSWD
    ${BASE_DIR}/mysql/bin/mysqladmin -uroot -p"${DEFAULT_PSWD}" password ${SET_PSWD}
    echo "You password for mysql5.7 are now ${SET_PSWD}."
}

## initialize the databases that mysql need.
create_db() {
    cd ${BASE_DIR}/mysql
    if [[ "$1" -eq "1" ]]; then
        scripts/mysql_install_db --datadir=/data/mysql --user=mysql
        [[ "$?" -eq 0 ]] && echo "Databases installed.`success`" || echo "Something wrong when install databases.`failure`"
    elif [[ "$1" -eq "2" ]]; then
        bin/mysqld --initialize --user=mysql --datadir=/data/mysql  &> /tmp/mysql5.7_databases_install.log
        [[ "$?" -eq 0 ]] && echo "Databases installed.`success`" || echo "Something wrong when install databases.`failure`"
    elif [[ "$1" -eq "3" ]]; then
        scripts/mysql_install_db --datadir=/data/mysql --user=mysql &> /tmp/mariadb10.2_databases_install.log
        [[ "$?" -eq 0 ]] && echo "Databases installed.`success`" || echo "Something wrong when install databases.`failure`"
    fi
}

## make mysql controlable via system
get_service_script_ready() {
    cp ${BASE_DIR}/mysql/support-files/mysql.server /etc/init.d/mysqld
}

if_mysql_running() {
service mysqld start
if lsof -i:3306; then
    echo "mysqld started successfully.`success`"
    chkconfig --add mysqld
    ln -s ${DATA_DIR}/mysql.sock /tmp/mysql.sock &> /dev/null
else
    echo "mysqld can't start.`failure`"
fi
}

## mysql5.7 need not to rum this.
secure_install() {
PASSWD="centos"
if rpm -q expect; then
    :
else
    yum install expect -y
fi
if [[ ! -e /tmp/mysql.sock ]]; then
    ln -s ${DATA_DIR}/mysql.sock /tmp/mysql.sock
fi
expect <<EOF
set timeout 10
spawn /usr/local/mysql/bin/mysql_secure_installation
expect {
"(enter for none)"       {send "\n";exp_continue}
"Set root password"      {send "y\n";exp_continue}
"New password:"          {send "${PASSWD}\n";exp_continue}
"Re-enter new password:" {send "${PASSWD}\n";exp_continue}
"users"                  {send "y\n";exp_continue}
"remotely"               {send "y\n";exp_continue}
"access to it"           {send "y\n";exp_continue}
"tables now"             {send "y\n"}
}
expect eof
EOF
[[ $? -eq 0 ]] && echo "Secure_installation complete,password for root is \"centos\"`success`" || echo "Something wrong during secure_installation.`failure`"
}

main() {

    #_test

    printf "\n%-255s\n" 1.${MYSQL_VER[0]} 2.${MYSQL_VER[1]} 3.${MYSQL_VER[2]}
    read -p "Select which version to install(1|2|3):" SELECT
    pre_install
    user_add
    deps_install
    get_binary_ready ${SELECT}
    configure_cnf
    path_ready
    create_db ${SELECT}
    get_service_script_ready
    if_mysql_running
    change_default_passwd
    if [[ ${SELECT} -ne 2 ]]; then
        secure_install
    fi
}

main
```

# 四.一键编译安装mysql二进制程序包脚本

```sh

```