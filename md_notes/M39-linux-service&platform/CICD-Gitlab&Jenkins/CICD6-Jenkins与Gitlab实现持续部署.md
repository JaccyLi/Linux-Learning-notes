环境：

| 主机名         | IP              |
| :------------- | :-------------- |
| gitlab-server  | 192.168.100.146 |
| Jenkins-server | 192.168.100.148 |

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

### 1.6.4 部署代码到后端服务器

# 二. Gitlab 触发 Jenkins 构建项目

# 三. 项目构建后触发动作
