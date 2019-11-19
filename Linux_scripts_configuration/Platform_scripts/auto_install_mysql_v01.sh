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
#
#
#######################
declare -a MYSQL_VER
WORKING_DIR=`pwd`
DATA_DIR="/data/mysql"
BASE_DIR="/usr/local"
SYS_VER=`cat /etc/redhat-release | sed -nr 's/.* ([0-9]+)\.[0-9]+\.?.*/\1/p'`
BINARY_NAME=
MYSQL_VER=( mysql-5.6 mysql-5.7 mariadb-10.2.29 )
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
