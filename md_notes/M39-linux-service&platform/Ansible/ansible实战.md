<center><font face="黑体" size="6" color="grey" >Ansible 实战</font></center>

# 1. httpd 角色

- 目录

```bash
root@ubuntu1904:~#tree  -f httpd/
httpd
├── httpd/default
│   └── httpd/default/main.yml
├── httpd/files
│   ├── httpd/files/httpd.conf
│   └── httpd/files/index.html
├── httpd/handlers
│   └── httpd/handlers/main.yml
├── httpd/tasks
│   ├── httpd/tasks/config.yml
│   ├── httpd/tasks/index.yml
│   ├── httpd/tasks/install.yml
│   ├── httpd/tasks/main.yml
│   ├── httpd/tasks/remove.yml
│   └── httpd/tasks/service.yml
├── httpd/templates
│   └── httpd/templates/httpd.conf.j2
└── httpd/vars
    └── httpd/vars/main.yml
```

- 各文件内容

`httpd/tasks/main.yml`

```yml
---
#- include: remove.yml
- include: install.yml
- include: config.yml
- include: index.yml
- include: service.yml
```

`httpd/tasks/install.yml`

```yml
---
- name: install httpd
  yum: name=httpd
```

`httpd/tasks/config.yml`

```yml
---
- name: config
  template: src=httpd.conf.j2 dest=/etc/httpd/conf/httpd.conf backup=yes
  notify: restart
```

`httpd/tasks/index.yml`

```yml
---
- name: index
  copy: src=index.html dest=/var/www/html
```

`httpd/tasks/service.yml`

```yml
---
- name: start service
  service: name=httpd enabled=yes state=started
```

`httpd/handlers/main.yml`

```yml
---
- name: restart
  service: name=httpd state=restarted
```

`httpd/tasks/remove.yml`

```yml
# remove httpd
- hosts: websrvs
  remote_user: root
  tasks:
    - name: remove httpd package
      yum: name=httpd state=absent
    - name: remove apache user
      user: name=apache state=absent
    - name: remove data file
      file: name=/etc/httpd  state=absent
...
```

`httpd/templates/httpd.conf.j2`

```yml
ServerRoot "/etc/httpd"
Listen {{ 80 }}
Include conf.modules.d/*.conf
User apache
Group apache
ServerAdmin root@localhost
<Directory />
    AllowOverride none
    Require all denied
</Directory>
DocumentRoot "/var/www/html"
<Directory "/var/www">
    AllowOverride None
    # Allow open access:
    Require all granted
</Directory>
<Directory "/var/www/html">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
<IfModule dir_module>
    DirectoryIndex index.html index.php index.htm
</IfModule>
<Files ".ht*">
    Require all denied
</Files>
ErrorLog "logs/error_log"
LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      # You need to enable mod_logio.c to use %I and %O
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>
    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>
<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>
AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>
#EnableMMAP off
EnableSendfile on

# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```

`role_httpd.yml`

```yml
root@ubuntu1904:/data/ansible_exercise#cat role_httpd.yml
---
- hosts: websrvs
  remote_user: root

  roles:
    - role: httpd
```

# 2. nginx 角色

- 目录

```bash
root@ubuntu1904:/data/ansible_exercise/roles#tree nginx/ -f
nginx
├── nginx/default
│   └── nginx/default/main.yml
├── nginx/files
│   ├── nginx/files/index.html
│   └── nginx/files/nginx.repo
├── nginx/handlers
│   └── nginx/handlers/main.yml
├── nginx/tasks
│   ├── nginx/tasks/config.yml
│   ├── nginx/tasks/file.yml
│   ├── nginx/tasks/install.yml
│   ├── nginx/tasks/main.yml
│   ├── nginx/tasks/repo.yml
│   └── nginx/tasks/service.yml
├── nginx/templates
│   ├── nginx/templates/nginx7.conf.j2
│   └── nginx/templates/nginx8.conf.j2
└── nginx/vars
    └── nginx/vars/main.yml
```

- 各文件内容

`nginx/tasks/main.yml`

```yml
---
- include: repo.yml
- include: install.yml
- include: config.yml
  tags: config
- include: file.yml
- include: service.yml
```

`nginx/tasks/repo.yml`

```yml
---
- name: copy yum repo for nginx
  copy: src=nginx.repo dest=/etc/yum.repos.d/
  notify: yum repolist
  tags: repo
```

`nginx/tasks/install.yml`

```yml
---
- name: install
  yum: name=nginx
```

`nginx/tasks/config.yml`

```yml
---
- name: config file for 7
  template: src=nginx7.conf.j2 dest=/etc/nginx/nginx.conf
  when: ansible_distribution_major_version=="7"
  notify: restart
- name: config file for 8
  template: src=nginx8.conf.j2 dest=/etc/nginx/nginx.conf
  when: ansible_distribution_major_version=="8"
  notify: restart
```

`nginx/tasks/file.yml`

```yml
---
- name: index.html
  copy: src=index.html dest=/usr/share/nginx/html/
```

`nginx/tasks/service.yml`

```yml
---
- name: service
  service: name=nginx state=started enabled=yes
```

`nginx/handlers/main.yml`

```yml
---
- name: yum repolist
  shell: yum clean all
- name: restart
  service: name=nginx state=restarted
```

`nginx/files/nginx.repo`

```py
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

`nginx/files/index.html`

```html
<DOCTYPE! html>
  <head>
    <p1>Hello There!</p1>
  </head>

  <body>
    <a>A test message!!</a>
  </body></DOCTYPE!
>
```

`nginx/templates/nginx7.conf.j2`

```jinja2
user  {{ user }};
worker_processes  {{ ansible_processor_vcpus**2 }};

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
                      access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
}
```

`nginx/templates/nginx8.conf.j2`

```jinja2
user nginx;
worker_processes  {{ ansible_processor_vcpus**2 }};

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
                      access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
}
```

`nginx/vars/main.yml`

```yml
---
user: daemon
```

`role_nginx.yml`

```yml
root@ubuntu1904:/data/ansible_exercise#cat role_nginx.yml
---
- hosts: websrvs
  remote_user: root

  roles:
    - role: nginx
```

# 3. memcached 角色

- 目录

```bash
root@ubuntu1904:/data/ansible_exercise/roles#tree memcached/ -f
memcached
├── memcached/default
├── memcached/handlers
├── memcached/tasks
│   ├── memcached/tasks/config.yml
│   ├── memcached/tasks/install.yml
│   ├── memcached/tasks/main.yml
│   └── memcached/tasks/service.yml
├── memcached/templates
│   └── memcached/templates/memcached.j2
└── memcached/vars
```

- 各文件内容

`memcached/tasks/main.yml`

```yml
- include: install.yml
- include: config.yml
- include: service.yml
```

`memcached/tasks/install.yml`

```yml
- name: install
  yum: name=memcached
```

`memcached/tasks/config.yml`

```yml
- name: config file
  template: src=memcached.j2  dest=/etc/sysconfig/memcached
```

`memcached/tasks/service.yml`

```yml
- name: service
  service: name=memcached state=started enabled=yes
```

`memcached/templates/memcached.j2`

```jinja2
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="{{ ansible_memtotal_mb//4 }}"
OPTIONS=""
```

`role_memcached.yml`

```yml
root@ubuntu1904:/data/ansible_exercise#cat role_memcached.yml
---
- hosts: websrvs

  roles:
    - role: memcached
```

# 4. mysql 角色

- 目录

```bash
root@ubuntu1904:/data/ansible_exercise#tree roles/mysqld/ -f
roles/mysqld
├── roles/mysqld/default
├── roles/mysqld/files
│   ├── roles/mysqld/files/my.cnf
│   ├── roles/mysqld/files/mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
│   └── roles/mysqld/files/secure_mysql.sh
├── roles/mysqld/handlers
│   └── roles/mysqld/handlers/main.yml
├── roles/mysqld/tasks
│   ├── roles/mysqld/tasks/config.yml
│   ├── roles/mysqld/tasks/data.yml
│   ├── roles/mysqld/tasks/group.yml
│   ├── roles/mysqld/tasks/install.yml
│   ├── roles/mysqld/tasks/link.yml
│   ├── roles/mysqld/tasks/main.yml
│   ├── roles/mysqld/tasks/path.yml
│   ├── roles/mysqld/tasks/remove_mysql.yml
│   ├── roles/mysqld/tasks/secure.yml
│   ├── roles/mysqld/tasks/service.yml
│   ├── roles/mysqld/tasks/unarchive.yml
│   └── roles/mysqld/tasks/user.yml
├── roles/mysqld/templates
└── roles/mysqld/vars
    └── roles/mysqld/vars/mysql_vars.yml
```

- 各文件内容

`roles/mysqld/tasks/main.yml`

```yml
---
- include: install.yml
- include: group.yml
- include: user.yml
- include: unarchive.yml
- include: link.yml
- include: data.yml
- include: config.yml
- include: service.yml
- include: path.yml
- include: secure.yml
```

`roles/mysqld/tasks/config.yml`

```yml
- name: config my.cnf
  copy: src=my.cnf  dest=/etc/my.cnf
```

`roles/mysqld/tasks/data.yml`

```yml
- name: data dir
  shell: chdir=/usr/local/mysql/  ./scripts/mysql_install_db --datadir=/data/mysql --user=mysql
```

`roles/mysqld/tasks/group.yml`

```yml
- name: create mysql group
  group: name=mysql gid=666
```

`roles/mysqld/tasks/install.yml`

```yml
- name: install deps libs
  yum: name=libaio,perl-Data-Dumper,perl-Getopt-Long
```

`roles/mysqld/tasks/link.yml`

```yml
- name: mkdir /usr/local/mysql
  file: src=/usr/local/mysql-5.6.46-linux-glibc2.12-x86_64 dest=/usr/local/mysql state=link
```

`roles/mysqld/tasks/path.yml`

```yml
- name: PATH variable
  copy: content='PATH=/usr/local/mysql/bin:$PATH' dest=/etc/profile.d/mysql.sh
```

`roles/mysqld/tasks/remove_mysql.yml`

```yml

```

`roles/mysqld/tasks/secure.yml`

```yml
- name: secure script
  script: secure_mysql.sh
```

`roles/mysqld/tasks/service.yml`

```yml
- name: service script
  shell: /bin/cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld;/etc/init.d/mysqld start;chkconfig --add mysqld;chkconfig mysqld on
```

`roles/mysqld/tasks/unarchive.yml`

```yml
- name: copy tar to remote host and file mode
  unarchive: src=mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz dest=/usr/local/ owner=root group=root
```

`roles/mysqld/tasks/user.yml`

```yml
- name: create mysql user
  user: name=mysql uid=667 group=mysql shell=/sbin/nologin system=yes create_home=no home=/data/mysql
```

`roles/mysqld/handlers/main.yml`

```yml
- name: restart
  shell: /etc/init.d/mysqld restart
```

`roles/mysqld/files/my.cnf`

```cnf
[mysqld]
log-bin
socket=/data/mysql/mysql.sock
user=mysql
symbolic-links=0
datadir=/data/mysql
innodb_file_per_table=1

[client]
port=3306
socket=/data/mysql/mysql.sock

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/data/mysql/mysql.pid
```

`roles/mysqld/files/secure_mysql.sh`

```bash
#!/bin/bash
/usr/local/mysql/bin/mysql_secure_installation <<EOF

y
stevenux
stevenux
y
y
y
y
EOF
```

`role_mysqld.yml`

```yml
root@ubuntu1904:/data/ansible_exercise#cat role_mysqld.yml
---
- hosts: websrvs
  remote_user: root
  roles:
    - role: mysqld
      tags: ["mysql", "db"]
```

# 5. PXC 角色

- 目录

```bash

```

- 配置文件可在我的 github 得到

  > [Github-ansible_exercise](https://github.com/JaccyLi/ansible_exercise)

- github 中目录如下

```bash
root@ubuntu1904:/data/ansible_exercise#tree
.
├── common_scripts
│   ├── loop.sh
│   ├── show_dir.sh
│   └── systeminfo.sh
├── README.rst
├── role_httpd.yml
├── role_memcached.yml
├── role_mysqld.retry
├── role_mysqld.yml
├── role_nginx.retry
├── role_nginx.yml
├── role_pxc.yml
└── roles
    ├── httpd
    │   ├── default
    │   │   └── main.yml
    │   ├── files
    │   │   ├── httpd.conf
    │   │   └── index.html
    │   ├── handlers
    │   │   └── main.yml
    │   ├── tasks
    │   │   ├── config.yml
    │   │   ├── index.yml
    │   │   ├── install.yml
    │   │   ├── main.yml
    │   │   ├── remove.yml
    │   │   └── service.yml
    │   ├── templates
    │   │   └── httpd.conf.j2
    │   └── vars
    ├── memcached
    │   ├── default
    │   ├── handlers
    │   ├── tasks
    │   │   ├── config.yml
    │   │   ├── install.yml
    │   │   ├── main.yml
    │   │   └── service.yml
    │   ├── templates
    │   │   └── memcached.j2
    │   └── vars
    ├── mysqld
    │   ├── default
    │   ├── files
    │   │   ├── my.cnf
    │   │   ├── mysql-5.6.46-linux-glibc2.12-x86_64.tar.gz
    │   │   └── secure_mysql.sh
    │   ├── handlers
    │   │   └── main.yml
    │   ├── tasks
    │   │   ├── config.yml
    │   │   ├── data.yml
    │   │   ├── group.yml
    │   │   ├── install.yml
    │   │   ├── link.yml
    │   │   ├── main.yml
    │   │   ├── path.yml
    │   │   ├── remove_mysql.yml
    │   │   ├── secure.yml
    │   │   ├── service.yml
    │   │   ├── unarchive.yml
    │   │   └── user.yml
    │   ├── templates
    │   └── vars
    │       └── mysql_vars.yml
    ├── nginx
    │   ├── default
    │   │   └── main.yml
    │   ├── files
    │   │   ├── index.html
    │   │   └── nginx.repo
    │   ├── handlers
    │   │   └── main.yml
    │   ├── tasks
    │   │   ├── config.yml
    │   │   ├── file.yml
    │   │   ├── install.yml
    │   │   ├── main.yml
    │   │   ├── repo.yml
    │   │   └── service.yml
    │   ├── templates
    │   │   ├── nginx7.conf.j2
    │   │   └── nginx8.conf.j2
    │   └── vars
    │       └── main.yml
    ├── pxc
    │   ├── default
    │   │   └── main.yml
    │   ├── files
    │   │   ├── percona.repo
    │   │   └── wsrep.cnf
    │   ├── handlers
    │   │   └── main.yml
    │   ├── tasks
    │   │   ├── install_pxc.retry
    │   │   ├── install_pxc.yml
    │   │   └── main.yml
    │   ├── templates
    │   └── vars
    │       └── main.yml
    └── self_report
        ├── self_report.j2
        ├── self_report.retry
        └── self_report.yml
```
