Nginx 高级配置

# 一.状态页

Nginx 状态页类似于 apache 和 php 使用的状态页面，基于`ngx_http_auth_basic_module`
实现，在编译安装 nginx 的时候需要添加编译参数`--with-http_stub_status_module`，
否则配置完成之后监测会是提⽰语法错误。

```bash
server {
        server_name blog.suosuoli.cn;
        keepalive_requests 5;
        keepalive_timeout 65 66;

        location /status {
                stub_status;
                allow 172.20.1.1;
                allow 127.0.0.1;
                deny all;
        }
```

访问`http://blog.suosuoli.cn/status`
![](png/2020-01-05-15-48-55.png)

说明

```bash
# 对齐一下是下面的样子
Active connections: 2
server accepts handled requests
       404     404     458
Reading: 0 Writing: 1 Waiting: 1

ctive connections： 当前处于活动状态的客⼾端连接数，包括连接等待空闲连接数。
accepts：统计总值，Nginx⾃启动后已经接受的客⼾端请求的总数。
handled：统计总值，Nginx⾃启动后已经处理完成的客⼾端请求的总数，通常等于accepts，除⾮有因
worker_connections的值限制等被拒绝的连接。
requests：统计总值，Nginx⾃启动后客⼾端发来的总的请求数。
Reading：当前状态，正在读取客⼾端请求报⽂⾸部的连接的连接数。
Writing：当前状态，正在向客⼾端发送响应报⽂过程中的连接数。
Waiting：当前状态，正在等待客⼾端发出请求的空闲连接数，开启 keep-alive的情况下,这个值
Waiting = Active connections – (Reading+Writing). 此处 1=2-1
```

# 二.第三方模块使用

Nginx 支持扩展第三方模块，第三⽅模块需要在编译安装 Nginx 的时候使⽤
参数`--add-module=PATH`指定路径添加，`PATH`是第三方模块的源码路径。
有的模块是由公司的开发⼈员针对业务需求定制开发的，有的模块是开源爱好者
开发好之后上传到 github 进⾏开源的模块，nginx ⽀持第三⽅模块需要从源码
重新编译⽀持，⽐如开源的 echo 模块。
[echo-github](https://github.com/openresty/echo-nginx-module)

```bash
[root@node1 data]# cd /usr/local/src
[root@node1 src]# git clone https://github.com/openresty/echo-nginx-module.git
Cloning into 'echo-nginx-module'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 3015 (delta 8), reused 11 (delta 5), pack-reused 2997
Receiving objects: 100% (3015/3015), 1.15 MiB | 16.00 KiB/s, done.
Resolving deltas: 100% (1619/1619), done.

[root@node1 src]# vim /apps/nginx/conf/nginx.conf
server {
     server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /status {
        stub_status;
        allow 172.20.1.1;
        allow 127.0.0.1;
        deny all;
        }

        location /echo1 {
                echo _sleep 1;
                echo This is echo1!!;
        }

        location /echo2 {
                echo _sleep 1;
                echo This is echo2!!;
        }
}

[root@node1 src]# nginx -s stop
# 五echo模块，报错，无法关闭nginx
nginx: [emerg] unknown directive "echo" in /etc/nginx/conf.d/blog.conf:31

# 注释掉echo配置
[root@node1 src]# nginx -s stop

[root@node1 src]# ll echo-nginx-module/
total 104
drwxr-xr-x 6 root root  4096 Jan  5 16:01 ./
drwxr-xr-x 3 root root  4096 Jan  5 16:00 ../
-rw-r--r-- 1 root root  3184 Jan  5 16:01 config
drwxr-xr-x 8 root root  4096 Jan  5 16:01 .git/
-rw-r--r-- 1 root root    27 Jan  5 16:01 .gitattributes
-rw-r--r-- 1 root root   618 Jan  5 16:01 .gitignore
-rw-r--r-- 1 root root  1345 Jan  5 16:01 LICENSE
-rw-r--r-- 1 root root 54503 Jan  5 16:01 README.markdown
drwxr-xr-x 2 root root  4096 Jan  5 16:01 src/
drwxr-xr-x 2 root root  4096 Jan  5 16:01 t/
-rw-r--r-- 1 root root  2216 Jan  5 16:01 .travis.yml
drwxr-xr-x 2 root root  4096 Jan  5 16:01 util/
-rw-r--r-- 1 root root   986 Jan  5 16:01 valgrind.suppress

# 编译安装
[root@node1 src]# cd nginx-1.16.1
[root@node1 nginx-1.16.1]# cd nginx-1.16.1
./configure  \
--prefix=/apps/nginx \
--user=nginx --group=nginx \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--with-pcre \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-http_perl_module \
--add-module=/usr/local/src/echo-nginx-module  # 指定第三方模块的源码路径

[root@node1 nginx-1.16.1]# make -f 4 && make install

[root@node1 src]# /apps/nginx/sbin/nginx -t
nginx: the configuration file /apps/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /apps/nginx/conf/nginx.conf test is successful

[root@node1 nginx-1.16.1]# vim /apps/nginx/conf/nginx.conf
server {
listen 80;
server_name localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /status {
        stub_status;
        allow 172.20.1.1;
        allow 127.0.0.1;
        deny all;
        }

        location /main {
                index index.html;
                default_type text/html;
                echo "Hello Nginx echo...";
                echo_reset_timer;
                echo_location /echo1;
                echo_location /echo2;
                echo "It took $echo_timer_elapsed secs to echo these words.";
        }


        location /echo1 {
                echo_sleep 1;
                echo This is echo1;
        }

        location /echo2 {
                echo_sleep 1;
                echo This is echo2;
        }
}

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# curl 172.20.2.37/echo1
This is echo1
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# curl 172.20.2.37/echo2
This is echo2

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# curl 172.20.2.37/main
Hello Nginx echo...
This is echo1
This is echo2
It took 2.002 secs to echo these words.`
```

访问`http://172.20.2.37/main`
![](png/2020-01-05-16-43-21.png)

# 三.Nginx 变量

nginx 的变量可以在配置⽂件中引⽤，作为功能判断或者⽇志等场景使⽤，变量可以分为
内置变量和⾃定义变量，内置变量是由 nginx 模块⾃带，通过变量可以获取到众多的与
客⼾端访问相关的值。

| 变量                | 含义                                                                                                                                                     |
| ------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------- |
| \$remote_addr;      | 存放了客⼾端的地址，注意是客⼾端的公⽹ IP，也就是⼀家⼈访问⼀个⽹站，则会显⽰为路由器的公⽹ IP。                                                         |
| \$args              | 变量中存放了 URL 中的指令，例如http://blog.suosuoli.cn/main/index.do?id=20190221&partner=search 中的 id=20190221&partner=search                          |
| \$document_root     | 保存了针对当前资源的请求的系统根⽬录，如/apps/nginx/html。                                                                                               |
| \$document_uri      | 保存了当前请求中不包含指令的 URI，注意是不包含请求的指令，⽐如http://blog.suosuoli.cn/main/index.do? id=20190221&partner=search 会被定义为/main/index.do |
| \$host              | 存放了请求的 host 名称。                                                                                                                                 |
| \$http_user_agent   | 客⼾端浏览器的详细信息                                                                                                                                   |
| \$http_cookie       | 客⼾端的 cookie 信息。                                                                                                                                   |
| limit_rate 10240;   | echo \$limit_rate; 如果 nginx 服务器使⽤ limit_rate 配置了显⽰⽹络速率，则会显⽰，如果没有设置， 则显⽰ 0。                                              |
| \$remote_port       | 客⼾端请求 Nginx 服务器时随机打开的端⼝，这是每个客⼾端⾃⼰的端⼝。                                                                                      |
| \$remote_user       | 已经经过 Auth Basic Module 验证的⽤⼾名。                                                                                                                |
| \$request_body_file | 做反向代理时发给后端服务器的本地资源的名称。                                                                                                             |
| \$request_method    | 请求资源的⽅式，GET/PUT/DELETE 等                                                                                                                        |
| \$request_filename  | 当前请求的资源⽂件的路径名称，由 root 或 alias 指令与 URI 请求⽣成的⽂件绝对路径， 如/apps/nginx/html/main/index.html                                    |
| \$request_uri       | 包含请求参数的原始 URI，不包含主机名，如：/main/index.do?id=20190221&partner=search。                                                                    |
| \$scheme            | 请求的协议，如 ftp，https，http 等。                                                                                                                     |
| \$server_protocol   | 保存了客⼾端请求资源使⽤的协议的版本，如 HTTP/1.0，HTTP/1.1，HTTP/2.0 等。                                                                               |
| \$server_addr       | 保存了服务器的 IP 地址。                                                                                                                                 |
| \$server_name       | 请求的服务器的主机名。                                                                                                                                   |
| \$server_port       | 请求的服务器的端⼝号。                                                                                                                                   |

例子：

```bash
[root@node1 nginx-1.16.1]# vim /apps/nginx/conf/nginx.conf
server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /status {
        stub_status;
        allow 172.20.1.1;
        allow 127.0.0.1;
        deny all;
        }
location /variables {
                index index.html;
                default_type text/html;

                echo "remote_addr is   : $remote_addr";
                echo "args in URL are  : $args";
                echo "document root is : $document_root";
                echo "document uri is  : $document_uri";
                echo "requested host is: $host";
                echo "user agent is    : $http_user_agent";
                echo "cookies in agent : $http_cookie";
                echo "the network speed: limit_rate";
                echo "user agent random port: $remote_port";
                echo "authed user is   : $remote_user";
                echo "to backend file  : $request_body_file";
                echo "request method   : $request_method";
                echo "requset file path: $request_filename"; # 如/apps/nginx/html/main/index.html
                echo "not include host : $request_uri";
                echo "protocol used    : $scheme";
                echo "spec protocol user agent used : $server_protocol";
                echo "server address   : $server_addr";
                echo "server hostname  : $server_name";
                echo "requested server port : $server_port";

        }
}

# 使用curl测试
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# curl 172.20.2.37/variables
remote_addr is   : 172.20.2.189
args in URL are  :
document root is : /apps/nginx/html
document uri is  : /variables
requested host is: 172.20.2.37
user agent is    : curl/7.58.0
cookies in agent :
the network speed: limit_rate
user agent random port: 60513
authed user is   :
to backend file  :
request method   : GET
requset file path: /apps/nginx/html/variables
not include host : /variables
protocol used    : http
spec protocol user agent used : HTTP/1.1
server address   : 172.20.2.37
server hostname  : localhost
requested server port : 80
```

访问`http://172.20.2.37/variables`
![](png/2020-01-05-18-25-44.png)

## 自定义变量

Nginx 的变量支持自定义变量。假如需要⾃定义变量名称和值，使⽤指令
`set \$variable value;`。具体⽅法如下：

```bash
Syntax: set $variable value; Default: — Context: server, location, if

set $name magedu;
echo $name;
set $my_port $server_port;
echo $my_port;
echo "$server_name:$server_port";
```

示例：

```bash
[root@node1 nginx-1.16.1]# vim /apps/nginx/conf/nginx.conf
 server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /status {
        stub_status;
        allow 172.20.1.1;
        allow 127.0.0.1;
        deny all;
        }


        location /my_info {
                index index.html;
                default_type text/html;
                set $my_name suosuoli;
                echo "My name is : $my_name";
                set $my_profession DevOps;
                echo "My profession is : $my_profession";
                set $my_hobbies Linux;
                echo "My hobbies are : $my_hobbies";
                set $my_host $server_addr;
                echo "I'm admin $my_host just for now.";
        }
 }

# curl 测试
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# curl 172.20.2.37/my_info
My name is : suosuoli
My profession is : DevOps
My hobbies are : Linux
I'm admin 172.20.2.37 just for now.
```

访问`http://172.20.2.37/my_info`
![](png/2020-01-05-18-44-18.png)

# 四.自定义访问日志

## 4.1 自定义日志

`access_log`访问⽇志用来记录客⼾端的具体请求内容信息;`error_log`错误日
志用在全局配置(http{...})块中指定服务器运行时的日志和记录的错误级别。

Nginx 的错误⽇志⼀般只有⼀个，但是访问⽇志可以在不同 server 中定义多个，
定义⼀个⽇志需要使⽤ access_log 指定⽇志的保存路径，使⽤ log_format 指
定⽇志的格式，格式中定义要保存的具体⽇志内容。

```bash
[root@node1 nginx-1.16.1]# vim /apps/nginx/conf/nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #access_log  logs/access.log  main;

    log_format  customize_log  '$remote_addr - $remote_user [$time_local] "$request" ';
    access_log  logs/access.log  customize_log;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65 66;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}

# 访问验证
[root@node1 html]# tail /apps/nginx/logs/access.log
......
172.20.1.1 - - [05/Jan/2020:20:14:44 +0800] "GET /my_info HTTP/1.1"
172.20.1.1 - - [05/Jan/2020:20:14:45 +0800] "GET /my_info HTTP/1.1"
172.20.1.1 - - [05/Jan/2020:20:14:45 +0800] "GET /my_info HTTP/1.1"
172.20.2.189 - - [05/Jan/2020:20:14:55 +0800] "GET / HTTP/1.1"
172.20.2.189 - - [05/Jan/2020:20:15:00 +0800] "GET / HTTP/1.1"
```

自定义日志如下图: 使用红色的指令指明定义日志格式和存放路径，使用绿色的框
写明自定义日志名称，黄色代表日志文件存储路径。
![](png/2020-01-05-20-18-48.png)

## 4.2 自定义 json 格式日志

Nginx 的默认访问⽇志记录内容相对⽐较单⼀，默认的格式也不⽅便后期做⽇志统
计分析，⽣产环境中通常将 nginx ⽇志转换为 json ⽇志，然后配合使⽤ ELK 等
工具做⽇志收集-统计-分析。典型的配置如下：

```json
log_format access_json '{"@timestamp":"$time_iso8601",'
        '"host":"$server_addr",'
        '"clientip":"$remote_addr",'
        '"size":$body_bytes_sent,'
        '"responsetime":$request_time,'
        '"upstreamtime":"$upstream_response_time",'
        '"upstreamhost":"$upstream_addr",'
        '"http_host":"$host",'
        '"uri":"$uri",'
        '"domain":"$host",'
        '"xff":"$http_x_forwarded_for",'
        '"referer":"$http_referer",'
        '"tcp_xff":"$proxy_protocol_addr",'
        '"http_user_agent":"$http_user_agent",'
        '"status":"$status"}';
     access_log  /apps/nginx/logs/access_json.log  access_json;
```

```bash
[root@node1 nginx-1.16.1]# vim /apps/nginx/conf/nginx.conf
http {
    include       mime.types;
    default_type  application/octet-stream;
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #access_log  logs/access.log  main;

    #log_format  customize_log  '$remote_addr - $remote_user [$time_local] "$request" ';
    #access_log  logs/access.log  customize_log;

    log_format  log_json  '{"@timestamp":"$time_iso8601",'
        '"host":"$server_addr",'
        '"clientip":"$remote_addr",'
        '"size":$body_bytes_sent,'
        '"responsetime":$request_time,'
        '"upstreamtime":"$upstream_response_time",'
        '"upstreamhost":"$upstream_addr",'
        '"http_host":"$host",'
        '"uri":"$uri",'
        '"domain":"$host",'
        '"xff":"$http_x_forwarded_for",'
        '"referer":"$http_referer",'
        '"tcp_xff":"$proxy_protocol_addr",'
        '"http_user_agent":"$http_user_agent",'
        '"status":"$status"}';
    access_log  /apps/nginx/logs/access_json_log  log_json;

    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65 66;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}

# 访问测试
[root@node1 html]# tail /apps/nginx/logs/access_json_log -f
{"@timestamp":"2020-01-05T20:25:45+08:00","host":"172.20.2.37","clientip":"172.20.1.1","size":136,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/my_info","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36","status":"200"}
{"@timestamp":"2020-01-05T20:25:49+08:00","host":"172.20.2.37","clientip":"172.20.1.1","size":136,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/my_info","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36","status":"200"}
{"@timestamp":"2020-01-05T20:26:01+08:00","host":"172.20.2.37","clientip":"172.20.1.1","size":136,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/my_info","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36","status":"200"}
{"@timestamp":"2020-01-05T20:26:07+08:00","host":"172.20.2.37","clientip":"172.20.2.189","size":612,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/index.html","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"curl/7.58.0","status":"200"}
{"@timestamp":"2020-01-05T20:26:13+08:00","host":"172.20.2.37","clientip":"172.20.2.189","size":612,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/index.html","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"curl/7.58.0","status":"200"}
{"@timestamp":"2020-01-05T20:26:13+08:00","host":"172.20.2.37","clientip":"172.20.2.189","size":612,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/index.html","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"curl/7.58.0","status":"200"}
{"@timestamp":"2020-01-05T20:26:38+08:00","host":"172.20.2.37","clientip":"172.20.1.1","size":555,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/sdf","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36","status":"404"}
{"@timestamp":"2020-01-05T20:26:47+08:00","host":"172.20.2.37","clientip":"172.20.1.1","size":555,"responsetime":0.000,"upstreamtime":"-","upstreamhost":"-","http_host":"172.20.2.37","uri":"/devops.png","domain":"172.20.2.37","xff":"-","referer":"-","tcp_xff":"","http_user_agent":"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36","status":"404"}
```

## 4.3 使用 Python 统计 json 格式日志

- 简单的处理程序

```py
#! /usr/bin/env python
#coding:utf-8
status_200 = []
status_404 = []
with open("access_json_log") as log_data:
    for line in log_data.readlines():
        line = eval(line)
        if line.get("status") == "200":
            status_200.append(line.get)
        elif line.get("status") == "404":
            status_404.append(line.get)
        else:
            print("status ERROR")
log_data.close()

#print( "There are :",len(status_200))
#print( "状态码404的有--:",len(status_404))
print(f'There are {len(status_200)} requests succeeded.')
print(f'There are {len(status_404)} requests for something not find.')
```

- 将日志文件和 python 处理程序放`/data`目录下测试

```bash
[root@node1 data]# ll
-rw-r--r-- 1 root  root     2968 Jan  5 20:36 access_json_log
-rw-r--r-- 1 root  root      624 Jan  5 20:37 log_analyses.py

[root@node1 data]# python3 log_analyses.py
There are 6 requests succeeded.
There are 2 requests for something not find.
```

# 五.https 配置

## 5.1 使用自签名证书

## 5.2 Nginx 证书配置

## 5.3 实现多域名 HTTPS

# 六.安全配置

## 6.1 隐藏 Nginx 版本号

通过修改

```bash
[root@node1 data]# vim nginx-1.16.1/src/http/ngx_http_header_filter_module.c
......
 47
 48
 49 static u_char ngx_http_server_string[] = "Server: nginx" CRLF;
 50 static u_char ngx_http_server_full_string[] = "Server: " NGINX_VER CRLF;
 51 static u_char ngx_http_server_build_string[] = "Server: " NGINX_VER_BUILD CRLF;
 52
......
# 将无符号字符串static u_char ngx_http_server_string[] 改为自己想改的字符串，比如
49 static u_char ngx_http_server_string[] = "Server: Suouoli-engine/1.0" CRLF;

# 再编译安装，就可以在浏览器的调试面板看到响应信息。如：
Server: Suosuoli-engine/1.0
```

## 6.2 升级 OpenSSL 版本

⼼脏出⾎（英语：Heartbleed），也简称为⼼⾎漏洞，是⼀个出现在加密程序库
OpenSSL 的安全漏洞，该程序库⼴泛⽤于实现互联⽹的传输层安全（TLS）协议。
它于 2012 年被引⼊了软件中，2014 年 4 ⽉⾸次向公众披露。只要使⽤的是存
在缺陷的 OpenSSL 实例，⽆论是服务器还是客⼾端，都可能因此⽽受到攻击。此
问题的原因是在实现 TLS 的⼼跳扩展时没有对输⼊进⾏适当验证（缺少边界检查），
因此漏洞的名称来源于“⼼跳”（heartbeat）。该程序错误属于缓冲区过读，即可
以读取的数据⽐应该允许读取的还多。

```bash
准备OpenSSL源码包：
# pwd
/usr/local/src
# tar xvf openssl-1.1.1d

编译安装Nginx并制定新版本OpenSSL路径：
# cd /usr/local/src/nginx-1.16.1/
#./configure  --prefix=/apps/nginx --user=nginx --group=nginx --with-http_ssl_module --
with-http_v2_module --with-http_realip_module --with-http_stub_status_module --with-
http_gzip_static_module --with-pcre --with-stream --with-stream_ssl_module --with-
stream_realip_module --with-select_module --with-file-aio --add-
module=/usr/local/src/echo-nginx-module --with-openssl=/usr/local/src/openssl-1.1.1d
# make && make install

验证并启动Nginx：
# /apps/nginx/sbin/nginx -t
nginx: the configuration file /apps/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /apps/nginx/conf/nginx.conf test is successful
# /apps/nginx/sbin/nginx
```

# 七.其它配置

## 7.1 Nginx 压缩功能

Nginx ⽀持对指定类型的⽂件进⾏压缩然后再传输给客⼾端，⽽且压缩还可以设置压缩
⽐例，压缩后的⽂件⼤⼩将⽐源⽂件显著变⼩，这样有助于降低出⼝带宽的利⽤率，降
低企业的 IT ⽀出，不过会占⽤相应的 CPU 资源。Nginx 对⽂件的压缩功能是依赖于模
块`ngx_http_gzip_module`[官⽅⽂档](https://nginx.org/en/docs/http/ngx_http_gzip_module.html)
配置指令如下：

```bash
#启⽤或禁⽤gzip压缩，默认关闭
gzip on | off;

#压缩⽐由低到⾼从1到9，默认为1
gzip_comp_level level;

#禁⽤IE6 gzip功能
gzip_disable "MSIE [1-6]\.";

#gzip压缩的最⼩⽂件，⼩于设置值的⽂件将不会压缩
gzip_min_length 1k;

#启⽤压缩功能时，协议的最⼩版本，默认HTTP/1.1
gzip_http_version 1.0 | 1.1;

#指定Nginx服务需要向服务器申请的缓存空间的个数*⼤⼩，默认32 4k|16 8k;
gzip_buffers number size;

#指明仅对哪些类型的资源执⾏压缩操作；默认为gzip_types text/html，不⽤显⽰指定，否则出错
gzip_types mime-type ...;

#如果启⽤压缩，是否在响应报⽂⾸部插⼊“Vary: Accept-Encoding”
gzip_vary on | off;
```

## 7.2 favicon.ico

favicon.ico ⽂件是浏览器收藏⽹址时显⽰的图标，也就是在每个浏览器的调板
上显示的图标。当客⼾端使⽤浏览器问⻚⾯时，浏览器会⾃⼰主动发起请求获取
⻚⾯的 favicon.ico ⽂件，但是当浏览器请求的 favicon.ico ⽂件不存在时，
服务器会记录 404 ⽇志，⽽且浏览器也会显⽰ 404 报错。

- 一般可以准备一个图标文件，并进行如下配置

```bash
#⼀：服务器不记录访问⽇志：
    #location = /favicon.ico {
      #log_not_found off;
      #access_log off;
    #}

#⼆：将图标保存到指定⽬录访问：
    #location ~ ^/favicon\.ico$ {
    location = /favicon.ico {
      root   /data/nginx/html/suosuoli/images;
      expires 90d; #设置⽂件过期时间
    }
```

- 如下图，划红线的就是没配置 favicon.ico 的站点
  ![](png/2020-01-05-20-46-52.png)
