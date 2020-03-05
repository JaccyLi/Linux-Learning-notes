# 一. 安装 grafana 并启用 zabbix 插件

```bash
# 下载grafana二进制rpm包
[root@zabbix-server1 ~]# wget wget https://dl.grafana.com/oss/release/grafana-6.6.2-1.x86_64.rpm

# 安装
[root@zabbix-server1 ~]# yum install grafana-6.6.2-1.x86_64.rpm

# 安装zabbix插件
[root@zabbix-server1 ~]# grafana-cli plugins  install alexanderzobnin-zabbix-app

# 重启grafana
[root@zabbix-server1 ~]# systemctl  restart grafana-server

```

# 二. 登录 grafana 启用 zabbix 插件

使用 3000 端口访问 grafana 登录页面:http://192.168.100.17/login
默认用户名和密码均为 admin
![](png/2020-03-04-08-52-56.png)

提示是否重置密码
![](png/2020-03-04-08-53-39.png)

进入主界面
![](png/2020-03-04-08-54-24.png)

# 三. 添加 MySQL 数据源

## 3.1 添加数据源

![](png/2020-03-04-08-55-09.png)

![](png/2020-03-04-08-55-42.png)

![](png/2020-03-04-08-56-06.png)

![](png/2020-03-04-09-07-03.png)

## 3.2 测试保存数据源

![](png/2020-03-04-09-07-17.png)

![](png/2020-03-04-09-07-34.png)

# 四. 添加 zabbix 数据源

红框中`http://192.168.100.17/zabbix/api_jsonrpc.php`

![](png/2020-03-04-15-53-10.png)
![](png/2020-03-04-15-54-08.png)

点击测试
![](png/2020-03-04-15-54-21.png)

# 五. 添加 Dashboard

![](png/2020-03-04-15-55-34.png)

![](png/2020-03-04-15-55-46.png)

![](png/2020-03-04-15-58-38.png)

![](png/2020-03-04-15-57-04.png)

![](png/2020-03-04-19-59-47.png)

![](png/2020-03-04-20-00-18.png)
