Nginx 核心配置

# 一.全局配置

## 1.1 Nginx 全局配置说明

```sh
user  nginx nginx;                 # 启动Nginx⼯作进程的⽤⼾和组
worker_processes  [number | auto]; # 启动Nginx⼯作进程的数量
worker_cpu_affinity 00000001 00000010 00000100 00001000;
# 将Nginx⼯作进程绑定到指定的CPU核⼼，默认Nginx是不进⾏进程绑定的，绑定并不是意味着当前nginx进程独
# 占以⼀核⼼CPU，但是可以保证此进程不会运⾏在其他核⼼上，这就极⼤减少了nginx的⼯作进程在不同的cpu核
# ⼼上的来回跳转，减少了CPU对进程的资源分配与回收以及内存管理等，因此可以有效的提升nginx服务器的性
# 能。 此处CPU有四颗核心

#错误⽇志记录配置，语法：error_log file  [debug | info | notice | warn | error | crit | alert | emerg]
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
error_log  /apps/nginx/logs/error.log error;

#pid⽂件保存路径
pid        /apps/nginx/logs/nginx.pid;

worker_priority 0; #⼯作进程nice值，-20~19
worker_rlimit_nofile 65536; #这个数字包括Nginx的所有连接（例如与代理服务器的连接等），⽽不仅仅是与
                            # 客⼾端的连接,另⼀个考虑因素是实际的并发连接数不能超过系统级别的最⼤打开⽂件数的限制.
[root@s2 ~]# watch -n1  'ps -axo pid,cmd,nice | grep nginx' #验证进程优先级

daemon off;  #前台运⾏Nginx服务⽤于测试、docker等环境。
master_process off|on; #是否开启Nginx的master-woker⼯作模式，仅⽤于开发调试场景。

events { #事件模型配置参数
    worker_connections  65536;  #设置单个⼯作进程的最⼤并发连接数
    use epoll; #使⽤epoll事件驱动，Nginx⽀持众多的事件驱动，⽐如select、poll、epoll，只能设置在events模块中设置。
    accept_mutex on; #优化同⼀时刻只有⼀个请求⽽避免多个睡眠进程被唤醒的设置，on为防⽌被同时唤醒默
                     # 认为off，全部唤醒的过程也成为"惊群"，因此nginx刚安装完以后要进⾏适当的优化。
    multi_accept on; # Nginx服务器的每个⼯作进程可以同时接受多个新的⽹络连接，但是需要在配置⽂件中
                     # 配置，此指令默认为关闭，即默认为⼀个⼯作进程只能⼀次接受⼀个新的⽹络连接，打开后⼏个同时接受多个。
}
```

## 1.2 http 配置块说明

```bash
http {
    include       mime.types; #导⼊⽀持的⽂件类型
    default_type  application/octet-stream; #设置默认的类型，会提⽰下载不匹配的类型⽂件

    #⽇志配置部分
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #access_log  logs/access.log  main;

    #⾃定义优化参数
    sendfile        on; #实现⽂件零拷⻉
    #tcp_nopush     on; #在开启了sendfile的情况下，合并请求后统⼀发送给客⼾端。
    #tcp_nodelay    off; #在开启了keepalived模式下的连接是否启⽤TCP_NODELAY选项，当为off时，延
                         # 迟0.2s发送，默认On时，不延迟发送，⽴即发送⽤⼾相应报⽂。
    #keepalive_timeout  0;
    keepalive_timeout  65 65; #设置会话保持时间
    #gzip  on; #开启⽂件压缩

server {
        listen       80; #设置监听地址和端⼝
        server_name  localhost; #设置server name，可以以空格隔开写多个并⽀持正则表达式，如
                                # *.magedu.com www.magedu.* www.(site\d+)\.magedu\.com$ default_server
        #charset koi8-r; #设置编码格式，默认是俄语格式，可以改为utf-8
        #access_log  logs/host.access.log  main;
        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html; #定义错误⻚⾯
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ { #以http的⽅式转发php请求到指定web服务器
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ { #以fastcgi的⽅式转发php请求到php处理
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht { #拒绝web形式访问指定⽂件，如很多的⽹站都是通过.htaccess⽂件来改变⾃⼰的重定向等功能。
        #    deny  all;
        #}
        location ~ /passwd.html {
            deny  all;
        }
        }

    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server { #⾃定义虚拟server
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm; #指定默认⽹⻚⽂件，此指令由ngx_http_index_module模块提供

    #    }
    #}

    # HTTPS server
    #
    #server { #https服务器配置
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    location  /linux38/passwd.ht {
      deny  all;
     }

    #}
```

# 二. 核心配置示例

基于不同的 IP、不同的端⼝以及不⽤得域名实现不同的虚拟主机，依赖于核⼼模块
ngx_http_core_module 实现。

## 2.1 新建⼀个 PC web 站点

```bash
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# vim blog.conf
server {
        listen 80;
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location /about {
        alias /var/www/html/about;
        index index.html;
        }
        }
}

root@ubuntu-suosuoli-node1:/var/www/html# mkdir suosuoli
root@ubuntu-suosuoli-node1:/var/www/html# vim suosuoli/index.html
root@ubuntu-suosuoli-node1:/var/www/html# cat suosuoli/index.html
<!DOCTYPE html>
<head>
It's a test messsage!
</head>
<body>
<h1>Nice , it works!!</h1>
</body>


root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# vim ../nginx.conf
include /apps/nginx/conf/conf.d/*.conf;
......
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

在`c:\Windows\System32\drivers\etc\hosts`新增一条解析
`172.20.2.189 blog.suosuoli.cn mob.suosuoli.cn`

然后访问验证`http://blog.suosuoli.cn`
![](png/2020-01-04-20-27-14.png)

## 2.2 新建一个移动端站点

```bash
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# vim mob.conf
server {
        listen 80;
        server_name mob.suosuoli.cn;
        location / {
                root /var/www/html/suosuoli-mob;
        }
}

root@ubuntu-suosuoli-node1:/var/www/html# mkdir suosuoli-mob

root@ubuntu-suosuoli-node1:/var/www/html# vim suosuoli-mob/index.html
root@ubuntu-suosuoli-node1:/var/www/html# cat suosuoli-mob/index.html
<!DOCTYPE html>
<head>
It's a test messsage!
</head>
<body>
<h1>Nice , it works!! BTW, this is your mobile site!!</h1>
</body>

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

然后访问验证`http://mob.suosuoli.cn`
![](png/2020-01-04-20-36-25.png)

## 2.3 root 与 alias 配置指令

root 指令用来指定 web 站点的根目录(家目录)，在使用 location 配置块时，
用户访问的文件的绝对路径为`root/location`，如：

```ruby
location /about {
    root /data/nginx/html;
    index index.html
}
```

此时用户访问`http://blog.suosuoli.cn/about`，则打开`/data/nginx/html/about/index.html`

alias 则是定义一个别名，使用 alias 定义的资源地址替代用户输入的 URI， 如：

```ruby
location /about {
    alias /data/suosuoli/about;
    index index.html
}
```

此时用户访问`http://blog.suosuoli.cn/about`，则打开`/data/suosuoli/about/index.html`

具体的例子

```bash
server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        # 用户最终访问到的内容/var/www/html/about1/index.html
        location /about1 {
        root /var/www/html;
        index index.html;
        }

        # 用户访问到的内容/about2-->/var/www/html/suosuoli/about/index.html
        location /about2 { #  #使⽤alias的时候URI后⾯如果加了斜杠则下⾯的路径配置必须加斜杠，否则403
        alias /var/www/html/suosuoli/about;
        index index.html;
        }
        }
}

# /var/www/html 下必须有一个目录名为 about ，这样使用roo指令才可以访问到/var/www/html/about
# 下的index.html
root@ubuntu-suosuoli-node1:/var/www/html# mkdir about1
root@ubuntu-suosuoli-node1:/var/www/html# vim about1/index.html
root@ubuntu-suosuoli-node1:/var/www/html# cat about1/index.html
I'm root.

root@ubuntu-suosuoli-node1:/var/www/html# mkdir suosuoli/about
root@ubuntu-suosuoli-node1:/var/www/html# echo "I'm alias." > suosuoli/about/index.html

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

访问`http://blog.suosuoli.cn/about1`

![](png/2020-01-04-21-12-04.png)
访问`http://blog.suosuoli.cn/about2`
![](png/2020-01-04-21-12-23.png)

## 2.4 location 配置指令的使用

使用`location`指令时，其匹配 URI 时可以支持正则表达式，该正则表达式遵循相应
的规则。在没有使⽤正则表达式的时候，nginx 会先在 server 配置块中的多个 location
选取匹配度最⾼的⼀个 URI(URI 也就是⽤⼾请求的字符串，即域名后⾯的 web 资源路径)，
如果匹配成功就结束搜索和匹配其它块，并使⽤此 location 处理此请求。

Nginx 的 location 中使用的正则符号规则如下：
语法规则： `location [=|~|~*|^~] /URI/ { … }`

| 匹配符号 | 规则                                                                                     |
| -------- | ---------------------------------------------------------------------------------------- |
| =        | ⽤于标准 URI 前，需要请求字串与 URI 精确匹配，如果匹配成功就停⽌向下匹配并⽴即处理请求。 |
| ~        | ⽤于标准 URI 前，表⽰包含正则表达式并且区分⼤⼩写，并且匹配                              |
| !~       | ⽤于标准 URI 前，表⽰包含正则表达式并且区分⼤⼩写，并且不匹配                            |
| ~\*      | ⽤于标准 URI 前，表⽰包含正则表达式并且不区分⼤写，并且匹配                              |
| !~\*     | ⽤于标准 URI 前，表⽰包含正则表达式并且不区分⼤⼩写,并且不匹配                           |
| ^~       | ⽤于标准 URI 前，表⽰包含正则表达式并且匹配以什么开头                                    |
| \$       | ⽤于标准 URI 前，表⽰包含正则表达式并且匹配以什么结尾                                    |
| \\       | ⽤于标准 URI 前，表⽰包含正则表达式并且转义字符。可以转. \* ?等                          |
| \*       | ⽤于标准 URI 前，表⽰包含正则表达式并且代表任意⻓度的任意字符                            |

如下图，红框 1 表示用户的请求 URI，红框 2 表示 Nginx 的 location 配置块
中事先定义的匹配字符，当红框 1 的内容和红框 2 的字符串满足正则规则时，就匹配
成功。
![](png/2020-01-04-21-27-24.png)

### 2.4.1 精确匹配访问资源

精确匹配时在 location 和 URI 之间使用`=`，这种用法通常用在长时间不变更
的资源上，例如

```bash
server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location = /devops.png {
        root /var/www/html/images;
        index index.html;
        }
}

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

访问`http://blog.suosuli.cn/devops.png`
![](png/2020-01-04-21-35-25.png)

### 2.4.2 URI 区分大小写匹配

区分大小写匹配，在 location 和 URI 之间使用`~`，例如：

```bash
server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location ~ /devop.?\.png {
        root /var/www/html/images;
        index index.html;
        }

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

访问:`http://blog.suosuoli.cn/devops.png`
访问:`http://blog.suosuoli.cn/devoPs.png`
![](png/2020-01-04-21-45-08.png)

### 2.4.3 URI 不区分大小写匹配

不区分大小写匹配，在 location 和 URI 之间使用`~*`，对⽤⼾请求
的 uri 做模糊匹配，也就是 uri 中⽆论都是⼤写、都是⼩写或者⼤⼩
写混合，此模式也都会匹配，通常使⽤此模式匹配⽤⼾ request 中的
静态资源并继续做下⼀步操作。例如：

```bash
server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location ~* /devop.?\.png {
        root /var/www/html/images;
        index index.html;
        }

注意：
# 对于不区分⼤⼩写的location，则可以访问任意⼤⼩写结尾的图⽚⽂件,如区分⼤⼩写则只
# 能访问aa.jpg，不区分⼤⼩写则可以访问aa.jpg以外的资源⽐如Aa.JPG、aA.jPG这样的混
# 合名称⽂件，但是要求nginx服务器的资源⽬录有相应的⽂件，⽐如有Aa.JPG有aA.jPG。

root@ubuntu-suosuoli-node1:/var/www/html# cp images/devops.png images/devoPs.png

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

访问:`http://blog.suosuoli.cn/devops.png`
访问:`http://blog.suosuoli.cn/devoPs.png`
![](png/2020-01-04-21-53-09.png)

### 2.4.4 以部分资源名称开头的匹配

```bash
root@ubuntu-suosuoli-node1:/var/www/html# mkdir suosuoli/{index1,index2} -pv
mkdir: created directory 'suosuoli/index1'
mkdir: created directory 'suosuoli/index2'
root@ubuntu-suosuoli-node1:/var/www/html# echo "index1" > suosuoli/index1/index.html
root@ubuntu-suosuoli-node1:/var/www/html# echo "index2" > suosuoli/index2/index.html

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# vim blog.conf
server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location ^~ /index1 {    # 注意：/var/www/html/suousoli下要有index1文件夹
        root /var/www/html/suosuoli;
        index index.html;
        }

        location /index2 {
        alias /var/www/html/suosuoli/index2;
        index index.html;
        }

}

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# nginx -s reload
```

访问：`http://blog.suosuoli.cn/index1`
访问：`http://blog.suosuoli.cn/index2`
![](png/2020-01-05-08-29-15.png)

### 2.4.5 以文件名后缀结尾的资源匹配

匹配以某些类型的文件后缀结尾的资源一般用于动静分离，即将对静态资源的访问定向
到某个位置，这些静态资源皆存储于此。

```bash
server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location ~* \.(gif|jpg|jpeg|bmp|webp|svg|png|tiff|tif|ico|wmf|js|css)$ {
        root /var/www/html/images;
        index picture.html;
        }

}
```

访问：`http://blog.suosuoli.cn/*.(png|svg|jpg|...)`
![](png/2020-01-05-08-47-29.png)

### 2.4.6 匹配优先级说明

location 配置块中的通配符的匹配顺序：
`= ---> ^~ ---> ~/~* ----> /`
即是：
`(location = URI {...}) ---> (location 完整URI {...}) --->`
`(location ^~ URI {...}) ---> (location ~/~* URI {...}) --->`
`(location 部分URI {...}) ---> (location / {...})`

```bash
location ~* /devops.jpg {
    index index.html;
    root /var/www/html/images;
  }

  location = /devops.jpg { #通常⽤于精确匹配指定⽂件，如favicon.ico、employcode.js、index.jsp等
    index index.html;
    root /var/www/html/suosuoli/images;
  }
```

由于优先级关系，以上配置将会导致访问:`http:blog.suosuoli.cn/devops.jpg`时
访问的是`/var/www/html/suosuoli/images/devops.jpg`

生产时大致可以如下配置匹配顺序：

```bash
location = / {   # 由于日常访问中，直接访问"/"的类型比较多，在第一个location配置"= /"可以加速访问，原因是在该处匹配后就立即处理请求了。
    /data/html;
    index index.html index.htm;
}

location / {
    ......;
}

# 接着配置静态资源的匹配规则，由于实际应用中大部分图片等静态资源常常由
# 应用命名，会自带各种字符，大小写字母夹杂，所以忽略大小写。
location ^~ /static/ {
    ......;
}
# 或者
location ~* \.(gif|jpg|jpeg|bmp|webp|svg|png|tiff|tif|ico|wmf|js|css)$ {
        root /var/www/html/static;
        index index.html;
        }

# 给多个web应用配置资源匹配规则
location ~* /application1 {
    ......;
}

location ~* /application2 {
    ......;
}
```

## 2.5 Nginx 四层访问控制

Nginx 的四层访问控制基于模块`ngx_http_access_module`实现，可以通过匹配
客户端 IP 地址进行限制。

```bash
root@ubuntu-suosuoli-node1:/var/www/html# mkdir red-zone
root@ubuntu-suosuoli-node1:/var/www/html# echo "It's red-zone,mind your behavior." > red-zone/index.html

server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location /red-zone {
        root /var/www/html;
        index index.html index.htm;
        deny 172.20.1.1;
        allow 172.20.0.0/16;
        deny all;
        }
}
```

物理机`172.20.1.1`访问:`http://blog.suosuoli.cn/red-zone/`
![](png/2020-01-05-09-24-11.png)

在`172.20.0.0/16`网段的另一台机子上修改一下 hosts 文件

```bash
vim /etc/hosts
172.20.2.37  blog.suosuoli.cn
```

并在`172.20.2.37`访问:`http://blog.suosuoli.cn/red-zone/`
![](png/2020-01-05-09-22-46.png)

## 2.6 Nginx 账户认证功能

```bash
root@ubuntu-suosuoli-node1:~# htpasswd -cmb /etc/nginx/conf.d/.htpasswd user1 stevenux
Adding password for user user1
root@ubuntu-suosuoli-node1:~# htpasswd -mb /etc/nginx/conf.d/.htpasswd user2 stevenux
Adding password for user user2
root@ubuntu-suosuoli-node1:~# cat /etc/nginx/conf.d/.htpasswd
user1:$apr1$Ldf9UL25$sKYSQJI7YU5QoP09DNckd.
user2:$apr1$5WMJZBsa$KAGjRkkmV1JuOnXcHBHus1

root@ubuntu-suosuoli-node1:/etc/nginx/conf.d# vim blog.conf

server {
        server_name blog.suosuoli.cn;
        location / {
                root  /var/www/html/suosuoli;
                index index.html index.htm;
        }

        location /red-zone {
        satisfy all;

        root /var/www/html;
        index index.html index.htm;
        deny 172.20.1.1;
        allow 172.20.0.0/16;
        deny all;

        auth_basic  "Input passwd to log in.";
        auth_basic_user_file conf.d/.htpasswd;
        }

}
```
![](png/2020-01-05-10-16-01.png)

## 2.7 自定义错误页面

## 2.8 自定义访问日志

## 2.9 try_files 指令

## 2.10 长连接配置

## 2.11 配置为下载服务器

## 2.12 配置为上传服务器

## 2.13 其它的配置
