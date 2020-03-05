# 一. zabbix 自动化部署

zabbix 自动化部署主要指自动化的部署 zabbix agent 主机，由于 zabbix server
主机或者 zabbix proxy 主机的数量往往比较少，而生产实践中要监控的主机往往
很多，如果一台一台的安装 zabbix agent 则不现实，这时可以考虑使用脚本通过
ssh 批量部署，或者使用 ansible 批量部署安装 zabbix agent。

## 1.1 编写脚本使用源码编译安装 zabbix agent

### 1.1.1 编写脚本

```bash
[root@zabbix-agent-node1 src]# cat compile_install_zabbix.sh
#!/bin/bash
#
# Edited by suosuoli.cn on 2020.03.05
#

WORK_DIR="/usr/local/src"
ZABBIX_VER="zabbix-4.0.15"

if [[ ! -e "${WORK_DIR}" ]]; then
    WORK_DIR=`pwd`
fi

## install some libs and deps.
if grep -iq "ubuntu" /etc/issue; then
    apt update
    apt -y install iproute2 ntpdate tcpdump telnet \
    apt -y install traceroute nfs-kernel-server nfs-common lrzsz tree \
    apt -y install openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev \
    apt -y install ntpdate tcpdump telnet traceroute gcc openssh-server \
    apt -y install lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev   \
    apt -y install zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip make
else
    yum install -y vim iotop bc gcc gcc-c++ glibc glibc-devel \
    yum install -y pcre  pcre-devel openssl  openssl-devel zip unzip zlib-devel\
    yum install -y net-tools lrzsz tree ntpdate telnet lsof tcpdump wget libevent \
    yum install -y libevent-devel bc systemd-devel bash-completion traceroute
fi


## compile zabbix and install
cd ${WORK_DIR}
tar -xf ${ZABBIX_VER}.tar.gz && \
            cd ${ZABBIX_VER} && \
            ./configure --prefix=/apps/zabbix_agent --enable-agent && \
            make && make install

## add user and create dir for pid file and log file
useradd zabbix
mkdir /apps/zabbix_agent/pid
mkdir /apps/zabbix_agent/logs

# copy conf file to the app folder
\cp ${WORK_DIR}/zabbix-agent.service    /lib/systemd/system/zabbix-agent.service
\cp ${WORK_DIR}/zabbix_agentd.conf      /apps/zabbix_agent/etc/zabbix_agentd.conf
\cp ${WORK_DIR}/zabbix_agentd.conf.d/*  /apps/zabbix_agent/etc/zabbix_agentd.conf.d/

## modify the zabbix hostname to ip.
HOST_IP=`ifconfig  eth0 | grep -w inet  | awk '{print $2}'`
sed -i "s/Hostname=/Hostname=${HOST_IP}/g" /apps/zabbix_agent/etc/zabbix_agentd.conf

chown zabbix.zabbix -R /apps/zabbix_agent/

systemctl daemon-reload
systemctl enable zabbix-agent
systemctl restart zabbix-agent
```

### 1.1.2 准备部署需要的文件

从原来的受 zabbix 监控的主机将监控脚本和 agent 监控入口配置文件拷贝到
新加的主机，此处`web-server-node2`为原有的受监控主机，`zabbix-agetn-node1`
为新加主机。

```bash
[root@web-server-node2 zabbix_agentd.d]# ll
total 32
-rw-r--r-- 1 root root 1479 Mar  3 11:09 customizedParams.conf
-rwxr-xr-x 1 root root  703 Mar  2 19:52 get_memcache_status.sh
-rwxr-xr-x 1 root root 1504 Mar  4 00:08 get_nginx_status.sh
-rwxr-xr-x 1 root root  563 Mar  2 21:50 get_redis_status.sh
-rwxr-xr-x 1 root root  524 Mar  1 18:29 get_tcp_status.sh
-rw-r--r-- 1 root root  319 Mar  5 15:10 get_token.py
-rw-r--r-- 1 root root  365 Mar  5 16:37 README.md
-rwxr-xr-x 1 root root 1239 Mar  5 15:56 sent_wechat_msg.py
[root@web-server-node2 zabbix_agentd.d]# scp get* cus* 192.168.100.24:/usr/local/src/
root@192.168.100.24's password:
get_memcache_status.sh     100%  703   234.8KB/s   00:00
get_nginx_status.sh        100% 1504     1.7MB/s   00:00
get_redis_status.sh        100%  563   542.9KB/s   00:00
get_tcp_status.sh          100%  524   210.2KB/s   00:00
get_token.py               100%  319   210.4KB/s   00:00
customizedParams.conf

[root@web-server-node2 zabbix_agentd.d]# scp /usr/lib/systemd/system/zabbix-agent.service 192.168.100.24:/usr/local/src/
root@192.168.100.24's password:
zabbix-agent.service       100%  434   196.2KB/s   00:00

[root@web-server-node2 zabbix_agentd.d]# scp /etc/zabbix/zabbix_agentd.conf 192.168.100.24:/usr/local/src/
root@192.168.100.24's password:
zabbix_agentd.conf           100%   11KB   2.7MB/s   00:00
```

```bash
[root@zabbix-agent-node1 src]# ll
[root@zabbix-agent-node1 src]# ll
total 16784
-rw-r--r--  1 root   root       1967 Mar  5 20:46 compile_install_zabbix.sh  # 部署安装脚本

# zabbix源码
-rw-r--r-- 1 root root 17163059 Feb 26 22:56 zabbix-4.0.15.tar.gz

# zabbix agent配置文件
-rw-r--r-- 1 root root    10864 Mar  5 21:06 zabbix_agentd.conf
drwxr-xr-x 2 root root      144 Mar  5 21:15 zabbix_agentd.conf.d

# zabbix systemd service文件
-rw-r--r-- 1 root root      474 Mar  5 21:05 zabbix-agent.service
[root@zabbix-agent-node1 src]# ll zabbix_agentd.conf.d/
total 20
-rw-r--r--  1 root   root       1544 Mar  5 20:49 customizedParams.conf  # 自定义监控项入口

# 各服务的监控脚本
-rwxr-xr-x 1 root root  703 Mar  5 20:40 get_memcache_status.sh
-rwxr-xr-x 1 root root 1504 Mar  5 20:40 get_nginx_status.sh
-rwxr-xr-x 1 root root  563 Mar  5 20:40 get_redis_status.sh
-rwxr-xr-x 1 root root  524 Mar  5 20:40 get_tcp_status.sh
-rw-r--r--  1 root   root   17163059 Feb 26 22:56 zabbix-4.0.15.tar.gz
```

#### 1.1.2.1 agent 配置文件

```bash
[root@zabbix-agent-node1 src]# grep "^[a-Z]" zabbix_agentd.conf
PidFile=/apps/zabbix_agent/pid/zabbix_agentd.pid
LogFile=/apps/zabbix_agent/logs/zabbix_agentd.log
DebugLevel=4
EnableRemoteCommands=1
LogRemoteCommands=1
Server=192.168.100.17
ListenPort=10050
ListenIP=0.0.0.0
StartAgents=5
ServerActive=127.0.0.1
Hostname=192.168.100.24  # 部署时会被脚本替换为相应主机ip
```

#### 1.1.2.2 agent service 文件

```bash
[root@zabbix-agent-node1 src]# cat zabbix-agent.service
[Unit]
Description=Zabbix Agent
After=syslog.target
After=network.target

[Service]
Environment="CONFFILE=/apps/zabbix_agent/etc/zabbix_agentd.conf"
EnvironmentFile=-/etc/sysconfig/zabbix-agent
Type=forking
Restart=on-failure
PIDFile=/apps/zabbix_agent/pid/zabbix_agentd.pid
KillMode=control-group
ExecStart=/apps/zabbix_agent/sbin/zabbix_agentd -c $CONFFILE
ExecStop=/bin/kill -SIGTERM $MAINPID
RestartSec=10s
User=zabbix
Group=zabbix

[Install]
WantedBy=multi-user.target
```

#### 1.1.2.3 自定义监控项入口

```bash
[root@zabbix-agent-node1 src]# cat zabbix_agentd.conf.d/customizedParams.conf
###################### TCP_STATUS Params Start ##############################
#$1 --> tcp_status
#$2 --> ESTAB|LISTEN|...
UserParameter=linux_tcp_status[*],/apps/zabbix_agent/etc/zabbix_agentd.conf.d/get_tcp_status.sh "$1" "$2"

###################### TCP_STATUS Params Stop  ##############################



###################### Memcached Status Params Start  ##############################
#$1 --> mem_status
#$2 --> 11211
#$3 --> curr_connections|uptime|threads|curr_connections|...
UserParameter=mem_status[*],/apps/zabbix_agent/etc/zabbix_agentd.conf.d/get_memcache_status.sh "$1" "$2" "$3"

###################### Memcached Status Params Stop   ##############################



###################### Redis Status Params Start  ##############################
#$1 --> redis_status
#$2 --> 6379
#$3 --> uptime_in_seconds|connected_clients|used_memory|used_memory_rss|used_memory_peak|total_connections_received|
#total_commands_processed|total_net_input_bytes|total_net_output_bytes|used_cpu_sys|used_cpu_user|...
UserParameter=redis_status[*],/apps/zabbix_agent/etc/zabbix_agentd.conf.d/get_redis_status.sh "$1" "$2" "$3"

###################### Redis Status Params Stop   ##############################



###################### Nginx Status Params Start   ##############################
#$1 --> active|accepts|handled|requests|reading|writing|waiting
UserParameter=nginx_status[*],/apps/zabbix_agent/etc/zabbix_agentd.conf.d/get_nginx_status.sh "$1"

###################### Nginx Status Params Stop    ##############################
```

#### 1.1.2.4 各监控脚本

1. TCP 状态监控

```bash
[root@zabbix-agent-node1 src]# cat zabbix_agentd.conf.d/get_tcp_status.sh
#!/bin/bash
#
# Edited on 2020.03.01 by suosuoli.cn
#
get_status(){
    STAT=$1
    STAT_NU=`ss -ant | \
	    awk 'NR!=1{ ++status[$1] }END{ for(stats in status) print stats, status[stats] }' | \
	    grep "${STAT}" | \
	    awk '{print $2}'`
    if [[ ${STAT_NU} -eq 0 ]]; then
        STAT_NU=0
    fi
    echo ${STAT_NU}
}

main(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: ./`basename $0` tcp_status <ESTAB|LISTEN|...>"
    fi
    case $1 in
        tcp_status)
	    get_status $2;
	    ;;
    esac
}

main $1 $2
```

2. memcache 状态监控

```bash
root@zabbix-agent-node1 src]# cat zabbix_agentd.conf.d/get_memcache_status.sh
#!/bin/bash
#
# Edited on 2020.03.02 by suosuoli.cn
#
# ubuntu : apt install nmap  -----> ncat

	# get status
get_memcached_status(){
echo -e "stats\nquit" | ncat 127.0.0.1 "$1" | grep "STAT $2" | awk '{print $3}'
}

main(){
	# prompt usage
    if [[ $# -eq 0 ]]; then
        echo "Usage: `basename $0` get_memcached_status <port> <status>"
    fi

	# install nmap if not installed.
    cat /etc/issue | grep -iq "ubuntu" 2>&1 /dev/null
    if [[ $? -ne 0 ]]; then
        yum install -y nmap &> /dev/null
    else
        apt update &> /dev/null && apt install -y nmap &> /dev/null
    fi

	# get status
    if [[ $1 = "mem_status" ]]; then
        get_memcached_status $2 $3
    fi
}

main $1 $2 $3
```

3. nginx 状态监控

```bash
[root@zabbix-agent-node1 src]# cat zabbix_agentd.conf.d/get_memcache_status.sh
#!/bin/bash
#
# Edited on 2020.03.02 by suosuoli.cn
#
# ubuntu : apt install nmap  -----> ncat

	# get status
get_memcached_status(){
echo -e "stats\nquit" | ncat 127.0.0.1 "$1" | grep "STAT $2" | awk '{print $3}'
}

main(){
	# prompt usage
    if [[ $# -eq 0 ]]; then
        echo "Usage: `basename $0` get_memcached_status <port> <status>"
    fi

	# install nmap if not installed.
    cat /etc/issue | grep -iq "ubuntu" 2>&1 /dev/null
    if [[ $? -ne 0 ]]; then
        yum install -y nmap &> /dev/null
    else
        apt update &> /dev/null && apt install -y nmap &> /dev/null
    fi

	# get status
    if [[ $1 = "mem_status" ]]; then
        get_memcached_status $2 $3
    fi
}

main $1 $2 $3
[root@zabbix-agent-node1 src]# cat zabbix_agentd.conf.d/get_nginx_status.sh
#!/bin/bash
#
# Edited on 2020.03.3 by suosuoli.cn
#

if [[ $# -eq 0 ]]; then
    echo "Usage: `basename $0` get_nginx_status.sh STATS"
fi

save_status(){
    /usr/bin/curl http://192.168.100.12/nginx_status 2> /dev/null > /tmp/nginx_status.log
}

get_port(){

    PORT=`ss -ntl | grep -w "80" | awk -F: '{print $2}' | cut -c1-2`
    if [[ "$PORT" = "80" ]]; then
        echo 1
    else
        echo 0
    fi
}

get_status(){
case $1 in
    active)
        active_conns=`/usr/bin/cat /tmp/nginx_status.log | grep -i "active" | awk '{print $3}'`;
        echo $active_conns;
;;
    accepts)
        accepts_conns=`/usr/bin/cat /tmp/nginx_status.log | grep  "^ [0-9]" | awk '{print $1}'`;
        echo $accepts_conns;
;;
    handled)
        handled_conns=`/usr/bin/cat /tmp/nginx_status.log | grep  "^ [0-9]" | awk '{print $2}'`;
        echo $handled_conns;
;;
    requests)
        requests_conns=`/usr/bin/cat /tmp/nginx_status.log | grep  "^ [0-9]" | awk '{print $3}'`;
        echo $requests_conns;
;;
    reading)
        reading_conns=`/usr/bin/cat /tmp/nginx_status.log | tail -n1 | awk '{print $2}'`;
        echo $reading_conns;
;;
    writing)
        writing_conns=`/usr/bin/cat /tmp/nginx_status.log | tail -n1 | awk '{print $4}'`;
        echo $writing_conns;
;;
    waiting)
        waiting_conns=`/usr/bin/cat /tmp/nginx_status.log | tail -n1 | awk '{print $6}'`;
        echo $waiting_conns;
;;
    port)
        get_port;
;;
esac
}

main(){
    save_status
    get_status $1
}

main $1

```

4. Redis 状态监控

```bash
[root@zabbix-agent-node1 src]# cat zabbix_agentd.conf.d/get_redis_status.sh
#!/bin/bash
#
# Edited on 2020.03.02 by suosuoli.cn
#


get_redis_status(){
echo -en "INFO \r\n" | ncat 127.0.0.1 $1 | grep -w "$2" | awk -F: '{print $2}'
}

main(){
	# install ncat if not installed
    cat /etc/issue | grep -iq "ubuntu"
    [[ $? -ne 0 ]] && yum install nmap-ncat -y &> /dev/null || apt install nmap-ncat -y &> /dev/null

	# prompt usage
    if [[ $# -eq 0 ]]; then
        echo "`basename $0` redis_status <PORT> <STATUS>"
    fi

	# do the f* thing
    if [[ $1 = "redis_status" ]]; then
        get_redis_status $2 $3
    fi
}

main $1 $2 $3
```

## 1.2 批量部署到不同主机

### 1.2.1 通过 ssh 使用脚本批量部署

将 zabbix agent 源码和编译安装脚本推送到远程主机，批量部署 zabbix agent

```bash

```

### 1.2.2 使用 ansible 批量部署

使用 ansible 将安装脚本和 zabbix 源码及配置文件等推送到远程主机，
再通过 ansible 运行该编译脚本，批量部署 zabbix agent

# 二. 使用 API 管理大量主机

## 2.1 管理 agent 常用 API

### 2.1.1 获取 token

```bash
[root@zabbix-server1 alertscripts]# curl -s -X POST -H 'Content-Type:application/json' -d '
> {"jsonrpc": "2.0",
> "method": "user.login",
> "params": {"user": "Admin",
> "password": "zabbix"
> },"id": 1}' http://192.168.100.17/zabbix/api_jsonrpc.php | python3 -m json.tool
{
    "jsonrpc": "2.0",
    "result": "e0634039ccf4c733f6aafd90122609ee",
    "id": 1
}
[root@zabbix-server1 alertscripts]#
```

### 2.1.2

## 2.2 批量添加 agent 到 zabbix server
