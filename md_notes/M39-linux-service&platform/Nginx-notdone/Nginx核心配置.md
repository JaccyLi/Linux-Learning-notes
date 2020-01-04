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

## 1.3 核心配置示例

基于不同的 IP、不同的端⼝以及不⽤得域名实现不同的虚拟主机，依赖于核⼼模块
ngx_http_core_module 实现。

### 1.3.1 新建⼀个 PC web 站点

### 1.3.2 新建一个移动端站点
