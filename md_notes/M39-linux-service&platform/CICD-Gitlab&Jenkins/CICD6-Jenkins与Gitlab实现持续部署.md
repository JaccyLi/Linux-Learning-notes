环境：

| 主机名              | IP              |
| :------------------ | :-------------- |
| gitlab-server       | 192.168.100.146 |
| Jenkins-server      | 192.168.100.148 |
| tomcat-server-node1 | 192.168.100.150 |
| tomcat-server-node1 | 192.168.100.152 |

# 一. 配置基于 SSH KEY 拉取代码

## 1.1 在 Jenkins 生成秘钥对

```bash
root@Jenkins-server:~# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:qqS6nFEktETN7yjdrUfRXyLjxgBrxN3+A+qQt4N9nNw root@Jenkins-server
The key\'s randomart image is:
+---[RSA 2048]----+
|.+o . . .        |
|o .o + . .       |
| o .o o o        |
|  o  + o * . .   |
|  ..= o S * o    |
| ..o = * + +     |
| .. . X = o .    |
|. oo + * = E     |
|o=. . . o        |
+----[SHA256]-----+

root@Jenkins-server:~# cat /root/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbWnoOk92XRnX49/sucan1En+V8vAdI1Xqwb1lp9LECythPRDvt7THfdUbGCNLB6qX2S01bvTLq9B2Lm5ekSOyFFVr+wUGBZRYJ2VurA4V9psGg5UZpQl+heiqXZIFdQxwTNLC3LRuMqomgNlfPfc6vp+rZloYsXw9F6m/quz8TjznK7tb1VjghhTSJEX8fEicM0QcKn/g0HLEKzgWqBhOnjdNY3zRsTg/eZY8eeTn4wTMDX5ra9Ek/DV6kvMMyhiydpGgJI5P5zoaKbc8dZ3Kzbe8RZNR/9LbC04mKd6A6sogj6GulZTT61qUAXcpVClHrST51e/Dc+ie87mJMUw9 root@Jenkins-server
```

## 1.2 将公钥添加到 gitlab

在 gitlab 网页端将 Jenkins-server 的 ssh 公钥添加到 gitlab

![](png/2020-03-10-22-34-26.png)

![](png/2020-03-10-22-34-45.png)

## 1.3 在 Jenkins 服务器测试使用 SSH 克隆项目

![](png/2020-03-10-22-38-11.png)

```bash
# 测试使用ssh协议克隆项目是否不用密码
root@Jenkins-server:~# git clone git@192.168.100.146:root/first-django-blog-project.git
Cloning into 'first-django-blog-project'...
remote: Enumerating objects: 283, done.
remote: Counting objects: 100% (283/283), done.
remote: Compressing objects: 100% (230/230), done.
remote: Total 283 (delta 34), reused 280 (delta 34)
Receiving objects: 100% (283/283), 1.16 MiB | 16.67 MiB/s, done.
Resolving deltas: 100% (34/34), done.

root@Jenkins-server:~# ls
first-django-blog-project
root@Jenkins-server:~# ll first-django-blog-project/
total 592
drwxr-xr-x 14 root root   4096 Mar 10 22:37 ./
drwx------  7 root root   4096 Mar 10 22:37 ../
drwxr-xr-x  5 root root   4096 Mar 10 22:37 article/
drwxr-xr-x  4 root root   4096 Mar 10 22:37 comment/
-rw-r--r--  1 root root 487424 Mar 10 22:37 db.sqlite3
drwxr-xr-x  8 root root   4096 Mar 10 22:37 .git/
-rw-r--r--  1 root root  35149 Mar 10 22:37 LICENSE
drwxr-xr-x  2 root root   4096 Mar 10 22:37 logs/
-rw-r--r--  1 root root    539 Mar 10 22:37 manage.py
drwxr-xr-x  2 root root   4096 Mar 10 22:37 md/
drwxr-xr-x  4 root root   4096 Mar 10 22:37 media/
drwxr-xr-x  3 root root   4096 Mar 10 22:37 my_blog/
drwxr-xr-x  4 root root   4096 Mar 10 22:37 notice/
drwxr-xr-x  2 root root   4096 Mar 10 22:37 __pycache__/
-rw-r--r--  1 root root     71 Mar 10 22:37 README.md
-rw-r--r--  1 root root    264 Mar 10 22:37 README.rst
-rw-r--r--  1 root root   4369 Mar 10 22:37 requirements.txt
drwxr-xr-x 10 root root   4096 Mar 10 22:37 static/
drwxr-xr-x  7 root root   4096 Mar 10 22:37 templates/
-rw-r--r--  1 root root    256 Mar 10 22:37 .travis.yml
drwxr-xr-x  4 root root   4096 Mar 10 22:37 userprofile/
```

## 1.4 在 Jenkins-server 网页端添加服务器私钥

Jenkins --> 凭据 --> jenkins --> 全局 --> 添加凭据

查看 Jenkins-server 的 ssh 私钥

```bash
root@Jenkins-server:~# cat /root/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAm1p6DpPdl0Z1+Pf7LnGp9RJ/lfLwHSNV6sG9ZafSxAsrYT0Q
77e0x33VGxgjSweql9ktNW70y6vQdi5uXpEjshRVa/sFBgWUWCdlbqwOFfabBoOV
GaUJfoXoql2SBXUMcEzSwty0bjKqJoDZXz33Or6fq2ZaGLF8PRepv6rs/E485yu7
W9VY4IYU0iRF/HxInDNEHCp/4NByxCs4FqgYTp43TWN80bE4P3mWPHnk5+MEzA1+
a2vRJPw1epLzDMoYsnaRoCSOT+c6Gim3PHWdys23vEWTUf/S2wtOJinegOrKII+h
rpWU0+talAF3KVQpR60k+dXvw3PonvO5iTFMPQIDAQABAoIBAC2ILw3muKOFuz3l
MHFETxPNACfqtAVWPfA4KFKLBXL/8w7k3vnjVdDCSJtQT8fFz3IB7QYkJwsqqEZ7
BU4iK9wdqYukXqyNJhVQNqJhOx+kz3rxRdnmTQoQJUkJc6q1y5d+bKdAGIHTx5rR
WORZPQSyqgmKTg2+tzMQpGfQqPSpZKxKOtqRBzGsIof+seE+igwPn56u7h4K11Em
zl9bGAxe1uSkajY9e3IyOedGOrzAjRtYfJqf/9ADodzzGCy8vPUpVlPZyK9XLIrs
6RDU2jtcNBk1VIgi8EF9WCPttXUM3CkGElKCDKjPa0twLNNm1ieT0Vv/X7T/O7h6
GZHBiAECgYEAzYvh0b6trCRL7OyQcNT888LPIZZdHdcyMR7R8f7OFEO6sfiq54Bl
GQ6d1SYP2CuXlzxMb6KKfteGzpxjbqi4/FiG23/YbeMeXlrlVnmj5V063X9YkMzx
E3J82d5t+fAN5PyfTDuJDjmqqikp7rh71sQdpAgAjdBVGY5zo7VsS8ECgYEAwXyR
yZAzsxi7HNwSXkVz4QXUkn+jNARhhFaUdJre7ai0Wa0RGFInhybd8E0cFQMnlAAP
NmgcyMJ74XnJuzJsCXQwK9/lY5T7qlpiEofHOwmVNJTewKk1qNokIU+nFUFl/sIH
o7PRJfb1rdIBieLGfuPQbJUP+bi0moDowtLgD30CgYB8zFSUk9BAt1z+AfgE+dyH
aB15CCGLT7Bi0JKp+opHFYRSMGgb3QIE/7Hmy5BNMNJ+eZbzJN4v+04XPi7E7l46
oMlolivjNEWpBkk+guZ3CW8HMx2j9TreEuIpKfreCNl20ccqcu9ZGrw7SnjyP0K5
eCODB3TGpdo1hR9DI5EYQQKBgQC/YnFuN/X7jFXg2QpON1LE3RiEBD6xgDfZSC62
HE6wM/SY02iabwDsXZSgUhWZ7zHh4iEqBteZ+U3CHM5fHSPiQgw4CdKDquU4fwiN
HcMC8ZqllS+00GrkZ0nfrUMu8i5qTRBza7VQYTRoR9b/xdHjx4HtNZDEyV/Th/k0
ZJP+nQKBgB+jMqhrXHY8xzD42xPt2zKapqqyzqcxrW/ChzSG/vrSLmKYDgTp93Yu
JHYVeMB0HJAd3sysBhScTnZPkJ6lJsKgPOSwoOIaZnAJth7A3rru2hcf+6sQKMB1
Kq97Q6gCuuifHnloI2W3x4sO6CJf+zlYmqY4fCCXYIjpWB9A4jFX
-----END RSA PRIVATE KEY-----
```

在 web 端将其添加到 Jenkins

![](png/2020-03-10-22-42-23.png)

![](png/2020-03-10-22-42-53.png)

![](png/2020-03-10-22-43-09.png)

![](png/2020-03-10-22-43-49.png)

![](png/2020-03-10-22-45-26.png)

![](png/2020-03-10-22-45-41.png)

## 1.5 在 Jenkins-server 网页端创建 project

![](png/2020-03-10-22-47-56.png)

## 1.6 在 project 中配置 git 项目地址和用户

![](png/2020-03-10-22-51-42.png)

## 1.7 测试构建项目

### 1.6.1 立即构建

![](png/2020-03-10-22-53-09.png)

### 1.6.2 验证构建结果

![](png/2020-03-10-22-54-21.png)

![](png/2020-03-10-22-57-26.png)

### 1.6.3 验证服务器数据

```bash
root@Jenkins-server:~# ll /var/lib/jenkins/workspace/Demo-01
total 592
drwxr-xr-x 14 jenkins jenkins   4096 Mar 10 22:53 ./
drwxr-xr-x  4 jenkins jenkins   4096 Mar 10 22:53 ../
drwxr-xr-x  5 jenkins jenkins   4096 Mar 10 22:53 article/
drwxr-xr-x  4 jenkins jenkins   4096 Mar 10 22:53 comment/
-rw-r--r--  1 jenkins jenkins 487424 Mar 10 22:53 db.sqlite3
drwxr-xr-x  8 jenkins jenkins   4096 Mar 10 22:53 .git/
-rw-r--r--  1 jenkins jenkins  35149 Mar 10 22:53 LICENSE
drwxr-xr-x  2 jenkins jenkins   4096 Mar 10 22:53 logs/
-rw-r--r--  1 jenkins jenkins    539 Mar 10 22:53 manage.py
drwxr-xr-x  2 jenkins jenkins   4096 Mar 10 22:53 md/
drwxr-xr-x  4 jenkins jenkins   4096 Mar 10 22:53 media/
drwxr-xr-x  3 jenkins jenkins   4096 Mar 10 22:53 my_blog/
drwxr-xr-x  4 jenkins jenkins   4096 Mar 10 22:53 notice/
drwxr-xr-x  2 jenkins jenkins   4096 Mar 10 22:53 __pycache__/
-rw-r--r--  1 jenkins jenkins     71 Mar 10 22:53 README.md
-rw-r--r--  1 jenkins jenkins    264 Mar 10 22:53 README.rst
-rw-r--r--  1 jenkins jenkins   4369 Mar 10 22:53 requirements.txt
drwxr-xr-x 10 jenkins jenkins   4096 Mar 10 22:53 static/
drwxr-xr-x  7 jenkins jenkins   4096 Mar 10 22:53 templates/
-rw-r--r--  1 jenkins jenkins    256 Mar 10 22:53 .travis.yml
drwxr-xr-x  4 jenkins jenkins   4096 Mar 10 22:53 userprofile/
```

## 1.8 部署代码到后端服务器

### 1.8.1 新建一个任务 tomcat-demo

该任务克隆 gitlab 的另一个项目`tomcat-demo`
![](png/2020-03-12-09-56-52.png)

新建后的项目
![](png/2020-03-12-09-54-45.png)

### 1.8.2 权限配置和免密通讯

Jenkins 使用 jenkins 用户启动，tomcat 使用 www 用户启动。使用 jenkins 用户和 tomcat 端
的 www 用户来免密通讯，以便以在 Jenkins 执行 job 构建时以非交互方式进行。

Jenkins-server 上的配置：

```bash
~# su - jenkins
~$ ssh-keygen
~$ ssh-copy-id www@192.168.100.150
~$ ssh-copy-id www@192.168.100.152
~$ exit
~#
```

Tomcat-server 上的配置

```bash
~# mkdir /data/tomcat/{webapps/app,appdir,webdir}
~# chown www.www /data/tomcat/ -R
~# chown www.www /usr/local/tomcat/ -R
```

### 1.8.3 Jenkins 执行脚本

```bash
#!/bin/bash

# 1. 打包源码
cd /var/lib/jenkins/workspace/tomcat-demo && tar -czvf app.tar.gz ./*

# 2. 停服务
ssh www@192.168.100.150 "/etc/init.d/tomcat stop"
ssh www@192.168.100.152 "/etc/init.d/tomcat stop"

# 3. 拷贝源码
scp -r app.tar.gz www@192.168.100.150:/data/tomcat/appdir/
scp -r app.tar.gz www@192.168.100.152:/data/tomcat/appdir/

# 4. 解压源码到tomcat加载目录
ssh www@192.168.100.150 "tar -xf /data/tomcat/appdir/app.tar.gz -C /data/tomcat/webapps/app/"
ssh www@192.168.100.152 "tar -xf /data/tomcat/appdir/app.tar.gz -C /data/tomcat/webapps/app/"

# 5. 启动tomcat
ssh www@192.168.100.150 "/etc/init.d/tomcat start"
ssh www@192.168.100.152 "/etc/init.d/tomcat start"
```

![](png/2020-03-12-09-33-46.png)

### 1.8.4 tomcat 端管理脚本

该脚本用来在将代码部署到 tomcat 服务器时给 tomcat 服务器的 www 用户管理
tomcat，部署前停止 tomcat，部署后启动 tomcat。

```bash
root@tomcat-server-node2:/data/tomcat/appdir# cat /etc/init.d/tomcat
#!/bin/bash
#
# Tomcat init script
# chkconfig: 2345 96 14
# Edited on 2020.03.12 by suosuoli.cn

JDK_HOME=/usr/local/jdk
CATALINA_HOME=/usr/local/tomcat
export JDK_HOME CATALINA_HOME
source /etc/profile

start() {
       	if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
   	    echo "Tomcat already running!!"
  	else
	    echo "Tomcat is dead. Now start Tomcat..."
  	    $CATALINA_HOME/bin/catalina.sh start  &> /dev/null
	    sleep 5
       	    if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
		PID=`ps -ef | grep  tomcat | grep jdk | awk '{print $2}'`
		PS_NUM=`ps -ef | grep  tomcat | grep jdk | awk '{print $2}' | wc -l`
  		echo  "Done. Tomcat now is running. PID=$PID"
	    else
		echo "Tomcat not start , start it again."
  	        $CATALINA_HOME/bin/catalina.sh start  &> /dev/null
	    fi
 	fi
	}

stop() {
	PID=`ps -ef  | grep  -v grep  | grep java | awk  '{print $2}'`
	PS_NUM=`ps -ef | grep  -v "color"  | grep tomcat | awk '{print $2}' | wc -l`
       	if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
	    echo "Tomcat is running, now stop..."
            $CATALINA_HOME/bin/catalina.sh stop  &> /dev/null
	    pkill java && pkill tomcat &> /dev/null
	    sleep 5
       	    if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
		PID=`ps -ef  | grep  -v grep  | grep java | awk  '{print $2}'`
		PS_NUM=`ps -ef | grep  -v "color"  | grep tomcat | awk '{print $2}' | wc -l`
		kill -9 $PID  &> /dev/null
	    else
  		echo  "Tomcat stop done."
	    fi
	else
		echo "Tomcat is not running."
	fi
	if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
            PID=`ps -ef  | grep  -v grep  | grep java | awk  '{print $2}'`
            echo "Tomcat still running, kill it..."
            pkill tomcat &> /dev/null;sleep 1
            if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
                echo "Still running."
                pkill java &> /dev/null; sleep 1
            fi
	fi
	}

restart() {
	stop
	start
 }

status(){
    if  netstat -an | grep 8080 | grep LISTEN >/dev/null;then
        echo 1
    else
	echo 0
    fi
}

case "$1" in
    start)
        start
;;

    stop)
        stop
;;

    restart)
        restart
;;

    status)
        status
;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
esac
```

# 二. Gitlab 触发 Jenkins 构建项目

Jenkins 可以使用令牌方式触发某个任务的运行，而 Gitlab 可以使用
webhook 来触发 Jenkins 运行某个任务。该 webhook 必须带有 Jenkins
的任务中事先定义的 token。如定义 token 为`1233211234567`，(不安全)

![](png/2020-03-12-10-06-59.png)

也可以使用如下方法生成 token：

```bash
root@Jenkins-server:/data/git/tomcat-demo# openssl rand -hex 64  # 生成64位长的token
80573e6516c3032b3c3170c00c96394dfc7dacc9684f896ec222dae2af8421291ccf4ee871a3755ecf54dc54cc7506ecb72dfefa2a45675b3bdc5356742c6e5c
```

构建触发器(webhook)，有的人称为钩子，实际上是一个 HTTP 回调,其用于在
开发人员向 gitlab 提交代码后能够触发 jenkins 自动执行代码构建操作。
比如在开发某个项目时，只有在开发人员向开发(develop)分支提交代码的时候
才会触发代码构建，而向主分支提交的代码不会自动构建，需要运维人员手动部
署代码到生产环境。

在 Gitlab 中配置 webhook 很简单，在 jenkins 的任务 URL 后加上`build?token=TOKEN`
就可以，此处 TOKEN=1233211234567：

![](png/2020-03-12-10-11-29.png)

## 2.1 新建一个任务

![](png/2020-03-12-10-01-12.png)

## 2.2 Jenkins 安装插件

系统管理 --> 管理插件 --> 可选插件
安装 Gitlab Hook 和 Gitlab Authentication

[注意事项](https://jenkins.io/security/advisory/2018-05-09/#SECURITY-263)

1. 在 jenkins 系统管理 --> 全局安全设置，认证改为登录用户可以做任何事情
2. 取消跨站请求伪造保护的勾选项
3. Gitlab Hook Plugin 以纯文本形式存储和显示 GitLab API 令牌

![](png/2020-03-12-10-43-09.png)

## 2.3 Gitlab 增加 System Hooks

![](png/2020-03-12-10-11-29.png)

![](png/2020-03-12-10-48-23.png)

## 2.4 Gitlab 项目新增 develop 分支

### 2.4.1 使用 git

```bash
~# git clone git@192.168.100.146:root/tomcat-demo.git
~# git branch -b develop
~# vim ...
~# git add --all
~# git commmit -m ""
~# git push
```

### 2.4.2 在 gitlab 的管理端

![](png/2020-03-12-10-19-07.png)

![](png/2020-03-12-10-19-34.png)

![](png/2020-03-12-10-19-52.png)

## 3.5 Jenkins 任务配置

![](png/2020-03-12-10-49-50.png)

### 3.5.1 git 仓库

![](png/2020-03-12-10-50-05.png)

### 3.5.2 触发器

![](png/2020-03-12-10-50-41.png)

### 3.5.3 构建测试脚本

![](png/2020-03-12-10-51-03.png)

## 3.6 测试触发构建

在其他的主机使用`curl`访问触发构建的 URL`http://192.168.100.148:8080/job/tomcat-demo-hook/build?token=1233211234567`
出现以下错误:

```bash
root@tomcat-server-node2:~# curl http://192.168.100.148:8080/job/tomcat-demo-hook/build?token=1233211234567
<html><head><meta http-equiv='refresh' content='1;url=/login?from=%2Fjob%2Ftomcat-demo-hook%2Fbuild%3Ftoken%3D1233211234567'/><script>window.location.replace('-color:white; color:white;'>


Authentication required
<!--
You are authenticated as: anonymous  # 匿名用户没有下面的权限
Groups that you are in:

Permission you need to have (but didn't): hudson.model.Hudson.Read
 ... which is implied by: hudson.security.Permission.GenericRead
 ... which is implied by: hudson.model.Hudson.Administer
-->

</body></html>
```

解决方法: 在 jenkins 全局安全配置中允许匿名用户读写权限

![](png/2020-03-12-10-34-19.png)

再次测试:

```bash
root@tomcat-server-node2:~# curl http://192.168.100.148:8080/job/tomcat-demo-hook/build?token=1233211234567
root@tomcat-server-node2:~# ip addr show eth0 | grep inet
    inet 192.168.100.152/24 brd 192.168.100.255 scope global eth0
    inet6 fe80::20c:29ff:fefe:598f/64 scope link
```

**触发构建成功** 提示是 192.168.100.152 触发的构建

![](png/2020-03-12-10-39-30.png)

## 3.7 在 Gitlab 测试 hook 可用性

![](png/2020-03-12-10-54-27.png)

HTTP 状态为 201，触发可用

![](png/2020-03-12-10-54-42.png)

## 3.8 编写部署 develop 分支的脚本

将开发分支部署到 tomcat-server-node2:192.168.100.152
而主分支部署到 tomcat-server-node1:192.168.100.150

将部署开发分支的 shell 命令更改为正式脚本:

```bash
#!/bin/bash

cd /var/lib/jenkins/workspace/tomcat-demo-hook
if [[ -f app.tar.gz ]]; then rm -rf app.tar.gz; fi
tar -czvf app.tar.gz ./*

#ssh www@192.168.100.150 "/etc/init.d/tomcat stop"
ssh www@192.168.100.152 "/etc/init.d/tomcat stop"

#scp -r app.tar.gz www@192.168.100.150:/data/tomcat/appdir/
scp -r app.tar.gz www@192.168.100.152:/data/tomcat/appdir/

#ssh www@192.168.100.150 "tar -xf /data/tomcat/appdir/app.tar.gz -C /data/tomcat/webapps/app/"
ssh www@192.168.100.152 "tar -xf /data/tomcat/appdir/app.tar.gz -C /data/tomcat/webapps/app/"

#ssh www@192.168.100.150 "/etc/init.d/tomcat start"
ssh www@192.168.100.152 "/etc/init.d/tomcat start"
```

## 3.9 在 Gitlab 的 tomcat-demo 的开发分支提交代码

在 Gitlab 的 tomcat-demo 的开发分支提交代码，看新的 Jenkins
任务`tomcat-demo-hook`是否自动构建并部署。

更改源代码，区分开发分支和主分支

![](png/2020-03-12-10-28-28.png)

![](png/2020-03-12-10-29-26.png)

## 3.10 查看 Jenkins 构建控制台输出进行验证

```bash
Started by remote host 192.168.100.146
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/tomcat-demo-hook
using credential 4bdb7583-344e-4b23-a037-52180ef6b2cc
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@192.168.100.146:root/tomcat-demo.git # timeout=10
Fetching upstream changes from git@192.168.100.146:root/tomcat-demo.git
 > git --version # timeout=10
using GIT_SSH to set credentials Private key of root.
 > git fetch --tags --progress -- git@192.168.100.146:root/tomcat-demo.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/develop^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/develop^{commit} # timeout=10
Checking out Revision 8b69cfddca891d69ca30e809cb8a8e85877b0614 (refs/remotes/origin/develop)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 8b69cfddca891d69ca30e809cb8a8e85877b0614 # timeout=10
Commit message: "Update index.jsp"   # 提交信息
 > git rev-list --no-walk f9f563a1ac76069ba139fe3ec050d1baed526cc3 # timeout=10
[tomcat-demo-hook] $ /bin/bash /tmp/jenkins259770157727169365.sh
./asf-logo-wide.svg
./bg-button.png
./bg-middle.png
./bg-nav-item.png
./bg-nav.png
./bg-upper.png
./favicon.ico
./index.jsp
./README.md
./RELEASE-NOTES.txt
./tomcat.css
./tomcat.gif
./tomcat.png
./tomcat-power.gif
./tomcat.svg
./WEB-INF/
./WEB-INF/web.xml
Tomcat is running, now stop...
pkill: killing pid 9891 failed: Operation not permitted  # 该处报错，脚本使用了www用户运行，权限不足
Tomcat is dead. Now start Tomcat...
Done. Tomcat now is running. PID=10361
Finished: SUCCESS   # 成功
```

## 3.11 查看页面变化

### 3.11.1 构建前

![](png/2020-03-12-20-53-49.png)
![](png/2020-03-12-20-53-31.png)

构建前页面一样

### 3.11.2 构建后

![](png/2020-03-12-20-57-16.png)

构建和部署后，开发分支的页面有变化，说明部署成功

![](png/2020-03-12-20-57-33.png)

# 三. 项目构建后触发动作

用于多个 job 相互关联，需要串行执行多个 job 的场景，可以通过安装插件
Parameterized Trigger 触发执行其他任务。

## 3.1 安装 Parameterized Trigger 插件

![](png/2020-03-12-21-20-51.png)

安装完成后重启 Jenkins

## 3.2 任务配置

![](png/2020-03-12-21-22-54.png)

![](png/2020-03-12-21-24-01.png)

增加个 email 通知
![](png/2020-03-12-21-25-09.png)

## 3.3 修改源码

### 3.3.1 master 分支主页面修改

![](png/2020-03-12-21-26-12.png)

![](png/2020-03-12-21-26-41.png)

### 3.3.2 develop 分支主页面修改

![](png/2020-03-12-21-27-47.png)

![](png/2020-03-12-21-28-03.png)

## 3.3 验证

### 3.3.1 点击立即构建 tomcat-demo 主分支

![](png/2020-03-12-21-33-21.png)

### 3.3.1 控制台输出

```bash
Started by user jenkinsadmin
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/tomcat-demo
using credential 4bdb7583-344e-4b23-a037-52180ef6b2cc
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git@192.168.100.146:root/tomcat-demo.git # timeout=10
Fetching upstream changes from git@192.168.100.146:root/tomcat-demo.git
 > git --version # timeout=10
using GIT_SSH to set credentials Private key of root.
 > git fetch --tags --progress -- git@192.168.100.146:root/tomcat-demo.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 6ae6f75d1ce250efeae82c04323e3591430bcdef (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 6ae6f75d1ce250efeae82c04323e3591430bcdef # timeout=10
Commit message: "Update index.jsp master"
 > git rev-list --no-walk cb5161854d5d676aa43ece9570f3380bdbe4d154 # timeout=10
[tomcat-demo] $ /bin/bash /tmp/jenkins2450948114439394446.sh
./asf-logo-wide.svg
./bg-button.png
./bg-middle.png
./bg-nav-item.png
./bg-nav.png
./bg-upper.png
./favicon.ico
./index.jsp
./README.md
./RELEASE-NOTES.txt
./tomcat.css
./tomcat.gif
./tomcat.png
./tomcat-power.gif
./tomcat.svg
./WEB-INF/
./WEB-INF/web.xml
Tomcat is running, now stop...
Tomcat stop done.
Tomcat is running, now stop...

tar: ./WEB-INF/web.xml: Cannot open: File exists
tar: ./WEB-INF: Cannot utime: Operation not permitted
tar: Exiting with failure status due to previous errors

Tomcat is dead. Now start Tomcat...

Done. Tomcat now is running. PID=1137
Tomcat is dead. Now start Tomcat...

Done. Tomcat now is running. PID=13564
Triggering a new build of tomcat-demo-hook  # 此处触发了开发分支的构建
Finished: SUCCESS

```

### 3.3.2 web 页面

![](png/2020-03-12-21-30-15.png)

![](png/2020-03-12-21-30-30.png)
