# 一. 环境准备

## 1.1 Ubuntu 环境

1. 允许 root 远程 ssh 连接

```bash
~$ sudo su - root
[sudo] password for stevenux:
~# passwd
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
~# vim /etc/ssh/sshd_config
...
PermitRootLogin yes
PasswordAuthentication yes
...
```

2. 网络配置

```bash
root@gitlab-server:~# cat /etc/netplan/01-netcfg.yaml
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.100.146/24]
      gateway4: 192.168.100.2
      nameservers:
        addresses: [192.168.100.2, 223.6.6.6]
```

3. 配置国内的软件源，比如：阿里云

```bash
root@gitlab-server:~# cat /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

4. 安装必要的库和基础工具

```bash
root@gitlab-server:~# apt update

root@gitlab-server:~# apt install iproute2  ntpdate  tcpdump telnet traceroute nfs-kernel-server \
> nfs-common  lrzsz tree  openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev ntpdate \
> tcpdump telnet traceroute  gcc openssh-server lrzsz tree openssl libssl-dev libpcre3 libpcre3-dev \
> zlib1g-dev ntpdate tcpdump telnet traceroute iotop unzip zip ipmitool -y
```

## 1.2 CentOS 环境

```bash
~# yum install vim gcc gcc-c++ wget net-tools lrzsz iotop lsof iotop bash-completion -y
~# yum install curl policycoreutils openssh-server openssh-clients postfix -y
~# wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
~# systemctl disable firewalld
~# sed -i '/SELINUX/s/enforcing/disabled/' /etc/sysconfig/selinux
~# hostnamectl set-hostname gitlab.example.com
~# reboot
```

# 二. 安装 Gitlab

## 2.1 下载安装包安装并配置

[官方 RPM 安装包下载地址](https://packages.gitlab.com/gitlab/gitlab-ce)

[RPM 包国内下载地址](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/)

[适用于 ubuntu 的.deb 包国内下载地址](https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu/pool/bionic/main/g/gitlab-ce/)

### 2.1.1 下载并安装

```bash
root@gitlab-server:~# wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu/pool/bionic/main/g/gitlab-ce/gitlab-ce_12.3.0-ce.0_amd64.deb

root@gitlab-server:~# dpkg -i gitlab-ce_12.3.0-ce.0_amd64.deb
Selecting previously unselected package gitlab-ce.
(Reading database ... 83898 files and directories currently installed.)
Preparing to unpack gitlab-ce_12.3.0-ce.0_amd64.deb ...
Unpacking gitlab-ce (12.3.0-ce.0) ...
Setting up gitlab-ce (12.3.0-ce.0) ...
It looks like GitLab has not been configured yet; skipping the upgrade script.

       *.                  *.
      ***                 ***
     *****               *****
    .******             *******
    ********            ********
   ,,,,,,,,,***********,,,,,,,,,
  ,,,,,,,,,,,*********,,,,,,,,,,,
  .,,,,,,,,,,,*******,,,,,,,,,,,,
      ,,,,,,,,,*****,,,,,,,,,.
         ,,,,,,,****,,,,,,
            .,,,***,,,,
                ,*,.



     _______ __  __          __
    / ____(_) /_/ /   ____ _/ /_
   / / __/ / __/ /   / __ \`/ __ \
  / /_/ / / /_/ /___/ /_/ / /_/ /
  \____/_/\__/_____/\__,_/_.___/


Thank you for installing GitLab!
GitLab was unable to detect a valid hostname for your instance.
Please configure a URL for your GitLab instance by setting `external_url`
configuration in /etc/gitlab/gitlab.rb file.
Then, you can start your GitLab instance by running the following command:
  sudo gitlab-ctl reconfigure

For a comprehensive list of configuration options please see the Omnibus GitLab readme
https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
```

### 2.1.2 配置

gitlab 配置文件为：`/etc/gitlab/gitlab.rb`

```bash
root@gitlab-server:~# vim /etc/gitlab/gitlab.rb
root@gitlab-server:~# grep "^[a-Z]" /etc/gitlab/gitlab.rb
external_url 'http://192.168.100.146'
gitlab_rails['gitlab_email_from'] = '1049103823@qq.com'
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.qq.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "1049103823@qq.com"
gitlab_rails['smtp_password'] = "vbydcytaggtzbbag"
gitlab_rails['smtp_domain'] = "qq.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
user['git_user_email'] = "1049103823@qq.com"
alertmanager['admin_email'] = 'stevobs@163.com'
```

### 2.1.3 初始化服务

执行刷新配置并启动服务：
使用 `gitlab-ctl reconfigure` 命令

```bash
root@gitlab-server:~# gitlab-ctl reconfigure
...
...
Recipe: gitlab::gitlab-rails
  * execute[clear the gitlab-rails cache] action run
    - execute /opt/gitlab/bin/gitlab-rake cache:clear
Recipe: <Dynamically Defined Resource>
  * service[gitaly] action restart
    - restart service service[gitaly]
Recipe: gitaly::enable
  * runit_service[gitaly] action hup
    - send hup to runit_service[gitaly]
Recipe: <Dynamically Defined Resource>
  * service[gitlab-workhorse] action restart
    - restart service service[gitlab-workhorse]
  * service[node-exporter] action restart
    - restart service service[node-exporter]
  * service[gitlab-exporter] action restart
    - restart service service[gitlab-exporter]
  * service[redis-exporter] action restart
    - restart service service[redis-exporter]
  * service[prometheus] action restart
    - restart service service[prometheus]
Recipe: monitoring::prometheus
  * execute[reload prometheus] action run
    - execute /opt/gitlab/bin/gitlab-ctl hup prometheus
Recipe: <Dynamically Defined Resource>
  * service[alertmanager] action restart
    - restart service service[alertmanager]
  * service[postgres-exporter] action restart
    - restart service service[postgres-exporter]
  * service[grafana] action restart
    - restart service service[grafana]

Running handlers:
Running handlers complete
Chef Client finished, 529/1417 resources updated in 02 minutes 48 seconds
gitlab Reconfigured!
```

### 2.1.4 gitlab 命令行常用命令

1. `gitlab-rails` 该命令用于启动控制台进行特殊操作，比如修改管理员密码、
   打开数据库控台( gitlab-rails dbconsole)等。

```bash
# dbconsole 子命令进入postgreSQL数据库
root@gitlab-server:~# gitlab-rails dbconsole
psql (10.9)
Type "help" for help.

gitlabhq_production=> \db
         List of tablespaces
    Name    |    Owner    | Location
------------+-------------+----------
 pg_default | gitlab-psql |
 pg_global  | gitlab-psql |
(2 rows)

gitlabhq_production=>\quit
```

2. `gitlab-psql` 进入数据库命令行

```bash
root@gitlab-server:~# gitlab-psql
psql (10.9)
Type "help" for help.

gitlabhq_production=# \db
         List of tablespaces
    Name    |    Owner    | Location
------------+-------------+----------
 pg_default | gitlab-psql |
 pg_global  | gitlab-psql |
(2 rows)

gitlabhq_production=#
```

3. `gitlab-rake` 数据备份恢复等数据操作命令
4. `gitlab-ctl` 客户端命令行操作行
5. `gitlab-ctl stop` 停止 gitlab
6. `gitlab-ctl start` 启动 gitlab
7. `gitlab-ctl restar` 重启 gitlab
8. `gitlab-ctl status` 查看组件运行状态
9. `gitlab-ctl tail` 查看某个组件的日志

```bash
root@gitlab-server:~# gitlab-ctl  tail nginx
==> /var/log/gitlab/nginx/error.log <==

==> /var/log/gitlab/nginx/gitlab_error.log <==

==> /var/log/gitlab/nginx/gitlab_access.log <==

==> /var/log/gitlab/nginx/access.log <==

==> /var/log/gitlab/nginx/current <==
2020-03-07_15:42:12.05412 2020/03/07 23:42:09 [emerg] 14393#0: still could not bind()
2020-03-07_15:42:12.06448 2020/03/07 23:42:12 [emerg] 14404#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:12.56566 2020/03/07 23:42:12 [emerg] 14404#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:13.06573 2020/03/07 23:42:12 [emerg] 14404#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:13.56686 2020/03/07 23:42:12 [emerg] 14404#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:14.06716 2020/03/07 23:42:12 [emerg] 14404#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:14.56749 2020/03/07 23:42:12 [emerg] 14404#0: still could not bind()
2020-03-07_15:42:14.57713 2020/03/07 23:42:14 [emerg] 14408#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:15.07731 2020/03/07 23:42:14 [emerg] 14408#0: bind() to 0.0.0.0:80 failed (98: Address already in use)
2020-03-07_15:42:15.57823 2020/03/07 23:42:14 [emerg] 14408#0: bind() to 0.0.0.0:80 failed (98: Address already in use)

```

10. `gitlab-ctl status` 查看当前 gitlab 运行情况

```bash
root@gitlab-server:~# gitlab-ctl status
run: alertmanager: (pid 12406) 1066s; run: log: (pid 12052) 1121s
run: gitaly: (pid 12248) 1069s; run: log: (pid 11465) 1208s
run: gitlab-exporter: (pid 12294) 1068s; run: log: (pid 11876) 1137s
run: gitlab-workhorse: (pid 12272) 1069s; run: log: (pid 11719) 1160s
run: grafana: (pid 12427) 1065s; run: log: (pid 12206) 1084s
run: logrotate: (pid 11756) 1150s; run: log: (pid 11782) 1149s
run: nginx: (pid 14408) 215s; run: log: (pid 11738) 1155s
run: node-exporter: (pid 12288) 1069s; run: log: (pid 11849) 1143s
run: postgres-exporter: (pid 12418) 1065s; run: log: (pid 12099) 1115s
run: postgresql: (pid 11484) 1206s; run: log: (pid 11533) 1203s
run: prometheus: (pid 12310) 1067s; run: log: (pid 12020) 1127s
run: redis: (pid 11323) 1218s; run: log: (pid 11330) 1215s
run: redis-exporter: (pid 12303) 1068s; run: log: (pid 11988) 1133s
run: sidekiq: (pid 11674) 1168s; run: log: (pid 11685) 1167s
run: unicorn: (pid 11645) 1174s; run: log: (pid 11670) 1173s
```

### 2.1.5 验证 nginx 端口

nginx 的 80 端口是在初始化 gitlib 的时候启动的，因此如果之前的
有程序占用会导致初始化失败或无法访问！

```bash
root@gitlab-server:~# lsof -i:80
COMMAND   PID       USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   14408       root    8u  IPv4 100257      0t0  TCP *:http (LISTEN)
nginx   14422 gitlab-www    8u  IPv4 100257      0t0  TCP *:http (LISTEN)
nginx   14423 gitlab-www    8u  IPv4 100257      0t0  TCP *:http (LISTEN)
```

### 2.1.6 登录 gitlab web 界面

第一次登录需要更改密码，最少 8 位

![](png/2020-03-08-00-00-13.png)

更改密码后，进入登录界面登录，默认用户为 `root`

![](png/2020-03-08-00-03-28.png)

### 2.1.7 默认首页

![](png/2020-03-08-00-04-07.png)

## 2.2 关闭 gitlab 的注册功能

默认情况下可以直接注册账号，企业内部使用一般都关闭次功能

关闭注册功能前的注册页面

![](png/2020-03-08-00-05-50.png)

取消该对勾

![](png/2020-03-08-10-55-56.png)

点击保存更改

![](png/2020-03-08-00-08-41.png)

登录界面已经没有注册选项

![](png/2020-03-08-00-10-13.png)

## 2.3 创建一个 git 用户

使用 admin 管理员账户创建一个开发使用的 git 账户，开发将使用该账户来
进行代码版本管理的相关事务。

从 admin area 进入用户、项目和组的管理界面

![](png/2020-03-08-11-02-21.png)

创建用户时的细节：
![](png/2020-03-08-11-05-27.png)
![](png/2020-03-08-11-07-40.png)
![](png/2020-03-08-11-09-19.png)
![](png/2020-03-08-11-10-18.png)

`stevie` 用户会收到设置密码的邮件:

![](png/2020-03-08-11-12-58.png)

点击设置密码的连接，跳转到 gitlab 更改密码界面

![](png/2020-03-08-11-15-50.png)

## 2.4 创建组

### 2.4.1 创建一个组

使用管理员账户 root 创建一个开发组。一个组里面可以有多个项目分支，可以
将开发添加到组里面进行设置权限，不同的组就是公司不同的开发项目或者服务
模块，不同的组添加不同的开发即可实现对开发设置权限的管理。

`Admin Area --> Dashboard --> New group`

![](png/2020-03-08-11-24-35.png)

创建组后，gitlab 配置文件中指定的邮箱发送通知邮件失败，是因为没
有在 gitlab 的 web 界面设置默认的管理员邮件

![](png/2020-03-08-11-47-20.png)

设置一下
![](png/2020-03-08-11-50-14.png)
收到邮件后确认
![](png/2020-03-08-11-49-51.png)

使用默认的账号创建组后接到通知
![](png/2020-03-08-11-51-43.png)

### 2.4.2 将用户 stevie 添加到组

在 Dashboard 找到要添加组员的组
![](png/2020-03-08-12-15-33.png)

选择要添加的组员
![](png/2020-03-08-12-16-05.png)

选择组员的角色
![](png/2020-03-08-12-16-22.png)

添加组员
![](png/2020-03-08-12-16-32.png)

stevie 已经添加
![](png/2020-03-08-12-16-53.png)

## 2.5 创建项目并测试

### 2.5.1 创建一个项目

使用 root 用户创建一个项目

![](png/2020-03-08-11-57-17.png)

项目概览
![](png/2020-03-08-12-00-53.png)

### 2.5.2 在项目新加一些代码和文件

新增一个官方网站的首页文件

![](png/2020-03-08-12-06-49.png)

再上传一个游戏源码文件

![](png/2020-03-08-12-10-18.png)
上传成功
![](png/2020-03-08-12-10-40.png)

项目概览
![](png/2020-03-08-12-10-59.png)

### 2.5.3 使用 git 测试下载代码和提交

#### 2.5.3.1 从 gitlab 克隆项目

获取 http 克隆连接

![](png/2020-03-08-12-28-04.png)

![](png/2020-03-08-12-28-20.png)

![](png/2020-03-08-12-29-33.png)

克隆该项目

```bash
root@gitlab-server:~# cd /da
-bash: cd: /da: No such file or directory
root@gitlab-server:~# mkdir /data
root@gitlab-server:~# cd /data
root@gitlab-server:/data# git clone http://192.168.100.146/game_dev_group0/first-pygame-project.git
Cloning into 'first-pygame-project'...
Username for 'http://192.168.100.146': stevie    # 输入git账户
Password for 'http://root@192.168.100.146':      # 输入git密码
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 9 (delta 1), reused 0 (delta 0)
Unpacking objects: 100% (9/9), done.
root@gitlab-server:/data# ls
first-pygame-project
root@gitlab-server:/data# ll first-pygame-project/
total 24
drwxr-xr-x 3 root root 4096 Mar  8 12:30 ./
drwxr-xr-x 3 root root 4096 Mar  8 12:29 ../
drwxr-xr-x 8 root root 4096 Mar  8 12:30 .git/
-rw-r--r-- 1 root root  117 Mar  8 12:30 index.html
-rw-r--r-- 1 root root 3322 Mar  8 12:30 main.py
-rw-r--r-- 1 root root   61 Mar  8 12:30 README.md

```

#### 2.5.3.2 修改代码

```bash
root@gitlab-server:/data# cd first-pygame-project/
root@gitlab-server:/data/first-pygame-project# ll
total 24
drwxr-xr-x 3 root root 4096 Mar  8 12:31 ./
drwxr-xr-x 3 root root 4096 Mar  8 12:31 ../
drwxr-xr-x 8 root root 4096 Mar  8 12:31 .git/
-rw-r--r-- 1 root root  117 Mar  8 12:31 index.html
-rw-r--r-- 1 root root 3322 Mar  8 12:31 main.py
-rw-r--r-- 1 root root   61 Mar  8 12:31 README.md

root@gitlab-server:/data/first-pygame-project# vim index.html
<DOCTYPE! html>
<head>
<h1>The Jumper Game<h1/>
<head/>
<body>
<p>This is our first pygame official page.<p/>
<p>Added some features to our game.<p/>  # 新增代码
<body/>
```

#### 2.5.3.3 提交

```bash
root@gitlab-server:/data/first-pygame-project# git config --global user.email stevobs@163.com
root@gitlab-server:/data/first-pygame-project# git config --global user.name "stevie"

root@gitlab-server:/data/first-pygame-project# git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:  # 还未添加到暂存区的被修改过的文件
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   index.html  # 该文件被修改过

no changes added to commit (use "git add" and/or "git commit -a")
root@gitlab-server:/data/first-pygame-project# git add index.html  # 使用git add 添加到暂存区
root@gitlab-server:/data/first-pygame-project# git commit -m "Added some feature to our game."  # 使用git commit命令提交到本地仓库
[master 26161e6] Added some feature to our game.
 1 file changed, 2 insertions(+), 1 deletion(-)
root@gitlab-server:/data/first-pygame-project# git push   # 将提交推送到gitlab端
Username for 'http://192.168.100.146': stevie    # git用户
Password for 'http://stevie@192.168.100.146':    # git密码
Counting objects: 3, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 388 bytes | 388.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: GitLab: You are not allowed to push code to protected branches on this project.  # 提示说master分支是受保护的，stevie不允许push操作
To http://192.168.100.146/game_dev_group0/first-pygame-project.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'http://192.168.100.146/game_dev_group0/first-pygame-project.git'
```

在 gitlab 中设置代码仓库，将`Protected Branches` 选项的`Allow to push` 选项选择为`Developer+Maintainers`

![](png/2020-03-08-12-49-17.png)

再次测试 push 操作

```bash
root@gitlab-server:/data/first-pygame-project# git push
Username for 'http://192.168.100.146': stevie
Password for 'http://stevie@192.168.100.146':
Counting objects: 3, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 388 bytes | 388.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: GitLab: You are not allowed to push code to protected branches on this project.
To http://192.168.100.146/game_dev_group0/first-pygame-project.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'http://192.168.100.146/game_dev_group0/first-pygame-project.git'
root@gitlab-server:/data/first-pygame-project# git push
Username for 'http://192.168.100.146': stevie
Password for 'http://stevie@192.168.100.146':
Counting objects: 3, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 388 bytes | 388.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
To http://192.168.100.146/game_dev_group0/first-pygame-project.git
   a7e8afc..26161e6  master -> master  # push成功
```

#### 2.5.3.4 到 gitlab web 端验证

![](png/2020-03-08-12-52-11.png)

# 三. Git 基础使用

## 3.1 Gitlab 的数据保存方式

**SVN 和 CVS**
每次提交的文件都单独保存，即按照文件的提交时间区分不同的版本，保存至不同
的逻辑存储区域，后期恢复的时候直接基于之前版本恢复。

**Gitlab**
Gitlab 与 SVN 的数据保存方式不一样，gitlab 虽然也会在内部对数据进行逻辑划
分保存，但是当后期提交的数据如果和之前提交过的数据没有变化，其就直接快照之
前的文件，而不是在将文件重新上传一份在保存一遍，这样既节省了空间又加快了代
码提交速度。

## 3.2 Git 基础使用

```bash
git config --global user.name "name"      # 设置全局用户名
git config --global user.email xxx@xx.com # 设置全局邮箱
git config --global  --list # 列出用户全局设置
git add index.html          # 添加指定文件到暂存区
git commit -m "init"        # 提交文件到工作区
git status     # 查看工作区的状态
git push       # 提交代码到服务器
git pull       # 获取仓库代码到本地
git log        # 查看操作日志
vim .gitignore # 定义忽略文件
git reset --hard HEAD^^ # git版本回滚， HEAD为当前版本，加一个^为上一个，^^为上上一个版本
git reflog               # 获取每次提交的ID，可以使用--hard根据提交的ID进行版本回退
git reset --hard 5ae4b06 # 回退到指定id的版本
git branch              # 查看当前所处的分支
git checkout -b develop  # 创建并切换到一个新分支
git checkout  develop    # 切换分支
```

## 3.3 Git 基本概念

**工作区**：clone 的代码或者开发自己编写的代码文件所在的目录，通常是代码所在
的目录名称，也就是整个项目的根目录。

**暂存区**：用于存储在工作区中对代码进行修改后的文件所保存的地方，使用`git add` 添加。

**本地仓库**：用于提交存储在工作区和暂存区中改过的文件地方，使用 git commi 提交

**远程仓库**：多个开发共同协作提交代码的仓库，即 gitlab 服务器仓库

# 四. Gitlab 数据备份恢复

## 4.1 停止 Gitlab 相应的数据服务

停止 Gitlab 的数据服务需要停止两个组件：

`Sidekiq`: 是一个 Ruby 后台作业处理器，它从 Redis 队列中提取作业并进行处理。
后台作业允许 GitLab 通过将工作转移到后台来提供更快的请求/响应周期

`Unicorn`: 是一个 Ruby 应用服务器，用于运行核心 Rails 应用程序，该应用程序
在 GitLab 中提供面向用户的功能，其处理的请求来源于 nginx 的代理转发。

```bash
root@gitlab-server:~# gitlab-ctl stop unicorn
ok: down: unicorn: 0s, normally up
root@gitlab-server:~# gitlab-ctl stop sidekiq
ok: down: sidekiq: 0s, normally up
```

## 4.2 备份数据

使用`gitlab-rake gitlab:backup:create`命令就可以创建一个完整的 gitlab
备份，使用`gitlab-rake gitlab:backup:restore`命令恢复，迁移到其它的
gitlab 服务器恢复也可以，保持两台服务器的 gitlab 版本相同，注意备份文件
的权限即可。该命令会备份 gitlab 仓库、数据库、用户、用户组、用户密钥、
权限等信息。postgresql 等的配置文件时未备份的。

```bash
root@gitlab-server:~# gitlab-rake gitlab:backup:create
2020-03-08 13:13:05 +0800 -- Dumping database ...
Dumping PostgreSQL database gitlabhq_production ... [DONE]
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping repositories ...
 * game_dev_group0/first-pygame-project (@hashed/6b/86/6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b) ... [DONE]
[SKIPPED] Wiki
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping uploads ...
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping builds ...
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping artifacts ...
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping pages ...
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping lfs objects ...
2020-03-08 13:13:06 +0800 -- done
2020-03-08 13:13:06 +0800 -- Dumping container registry images ...
2020-03-08 13:13:06 +0800 -- [DISABLED]
Creating backup archive: 1583644386_2020_03_08_12.3.0_gitlab_backup.tar ... done
Uploading backup archive to remote storage  ... skipped
Deleting tmp directories ... done
done
done
done
done
done
done
done
Deleting old backups ... skipping  # 没有旧的备份，跳过

# 该警告表示：gitlab.rb 和 gitlab-secrets.json配置文件中含有敏感信息，需要手动备份
Warning: Your gitlab.rb and gitlab-secrets.json files contain sensitive data
and are not included in this backup. You will need these files to restore a backup.
Please back them up manually.
Backup task is done.

# 备份完后重新启动gitlab
root@gitlab-server:~# gitlab-ctl start
ok: run: alertmanager: (pid 24040) 6414s
ok: run: gitaly: (pid 12248) 49625s
ok: run: gitlab-exporter: (pid 12294) 49624s
ok: run: gitlab-workhorse: (pid 12272) 49625s
ok: run: grafana: (pid 12427) 49621s
ok: run: logrotate: (pid 35356) 894s
ok: run: nginx: (pid 14408) 48771s
ok: run: node-exporter: (pid 12288) 49625s
ok: run: postgres-exporter: (pid 12418) 49621s
ok: run: postgresql: (pid 11484) 49762s
ok: run: prometheus: (pid 12310) 49623s
ok: run: redis: (pid 11323) 49774s
ok: run: redis-exporter: (pid 12303) 49624s
ok: run: sidekiq: (pid 36511) 1s
ok: run: unicorn: (pid 36517) 0s

# 手动备份gitlab配置文件和KEY文件
root@gitlab-server:~# cp /etc/gitlab/gitlab.rb /var/opt/gitlab/backups/
root@gitlab-server:~# cp /etc/gitlab/gitlab-secrets.json /var/opt/gitlab/backups/
```

**重要目录和文件**

```bash
# Gitlab数据备份目录，使用命令备份
root@gitlab-server:~# ll /var/opt/gitlab/backups/
-rw-------  1 git  git  348160 Mar  8 13:13 1583644386_2020_03_08_12.3.0_gitlab_backup.tar
# nginx配置文件
root@gitlab-server:~# ll /var/opt/gitlab/nginx/conf/
total 20
drwxr-x--- 2 root gitlab-www 4096 Mar  8 11:28 ./
drwxr-x--- 9 root gitlab-www 4096 Mar  7 23:42 ../
-rw-r--r-- 1 root root       4023 Mar  7 23:26 gitlab-http.conf
-rw-r--r-- 1 root root       2978 Mar  7 23:26 nginx.conf
-rw-r--r-- 1 root root        603 Mar  7 23:26 nginx-status.conf
# gitlab配置文件
root@gitlab-server:~# ll /etc/gitlab/gitlab.rb
-rw------- 1 root root 94975 Mar  8 11:27 /etc/gitlab/gitlab.rb
# KEY文件
root@gitlab-server:~# ll /etc/gitlab/gitlab-secrets.json
-rw------- 1 root root 15619 Mar  8 11:28 /etc/gitlab/gitlab-secrets.json
```

## 4.3 破坏一些数据

破坏数据前
![](png/2020-03-08-14-33-21.png)

```bash
# 备份一下要破坏的数据，万一恢复不了呢。
root@gitlab-server:~# mkdir /data ; cp -av /var/opt/gitlab/git-data/repositories /data

# 删除git仓库数据
root@gitlab-server:~# rm -rf /var/opt/gitlab/git-data/repositories

# 辛辛苦苦写的代码没了
root@gitlab-server:~# ll /var/opt/gitlab/git-data/repositories
ls: cannot access '/var/opt/gitlab/git-data/repositories': No such file or directory
```

破坏数据后：
![](png/2020-03-08-14-34-20.png)
![](png/2020-03-08-14-36-38.png)

## 4.4 恢复数据

```bash
root@gitlab-server:~# gitlab-ctl stop sidekiq
ok: down: sidekiq: 0s, normally up
root@gitlab-server:~# gitlab-ctl stop unicorn
ok: down: unicorn: 0s, normally up

root@gitlab-server:~# gitlab-rake gitlab:backup:restore BACKUP=1583644386_2020_03_08_12.3.0
Unpacking backup ... done
Before restoring the database, we will remove all existing
tables to avoid future upgrade problems. Be aware that if you have
custom tables in the GitLab database these tables and all data will be
removed.

Do you want to continue (yes/no)? yes  # 第一个交互界面，问是否允许重新创建所有的数据库表
...
...
ALTER TABLE
WARNING:  no privileges were granted for "public"
GRANT
[DONE]
2020-03-08 13:32:51 +0800 -- done
2020-03-08 13:32:51 +0800 -- Restoring repositories ...
 * game_dev_group0/first-pygame-project ... [DONE]
2020-03-08 13:32:51 +0800 -- done
2020-03-08 13:32:51 +0800 -- Restoring uploads ...
2020-03-08 13:32:51 +0800 -- done
2020-03-08 13:32:51 +0800 -- Restoring builds ...
2020-03-08 13:32:51 +0800 -- done
2020-03-08 13:32:51 +0800 -- Restoring artifacts ...
2020-03-08 13:32:51 +0800 -- done
2020-03-08 13:32:51 +0800 -- Restoring pages ...
2020-03-08 13:32:51 +0800 -- done
2020-03-08 13:32:51 +0800 -- Restoring lfs objects ...
2020-03-08 13:32:51 +0800 -- done
This task will now rebuild the authorized_keys file.
You will lose any data stored in the authorized_keys file.
Do you want to continue (yes/no)? yes  # 第二个交互界面，问是否重新构建KEY文件

Deleting tmp directories ... done
done
done
done
done
done
done
done
Warning: Your gitlab.rb and gitlab-secrets.json files contain sensitive data
and are not included in this backup. You will need to restore these files manually.
Restore task is done.
```

查看恢复的数据

```bash
root@gitlab-server:~# ll /var/opt/gitlab/git-data/repositories/
total 16
drwx------ 4 git git  4096 Mar  8 14:38  ./
drwx------ 3 git root 4096 Mar  8 14:38  ../
drwx------ 3 git git  4096 Mar  8 14:38  +gitaly/
drwxr-x--- 3 git git  4096 Mar  8 14:38 '@hashed'/
```

## 4.5 启动 Gitlab 相应的数据服务

未启动数据服务：
![](png/2020-03-08-13-57-05.png)

启动服务

```bash
root@gitlab-server:~# gitlab-ctl start sidekiq
ok: run: sidekiq: (pid 42354) 0s
root@gitlab-server:~# gitlab-ctl start unicorn
ok: run: unicorn: (pid 42306) 17s

# 或者直接
~# gitlab-ctl restart
```

OK，熟悉的界面回来了
![](png/2020-03-08-13-57-32.png)
