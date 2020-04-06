# Linux文件及作用

| 文件                                     | 作用                                                     | 备注                          |
| :--------------------------------------- | :------------------------------------------------------- | :---------------------------- |
| CentOS                                   |                                                          |                               |
| /etc/sysctl.conf                         | 修改和存放内核参数                                       | 使用`sysctl -p`让内核参数生效 |
| /proc/net/nf_conntrack                   | iptables 的 state 扩展模块已经追踪到并记录下来的连接信息 |                               |
| /proc/sys/net/netfilter/nf_conntrack_max | 调整连接追踪功能所能够容纳的最大连接数量                 |                               |






# 内核优化

## **sysctl**

- 默认配置文件：/etc/sysctl.conf 

- (1) 设置某参数  `sysctl -w parameter=VALUE`

- (2) 通过读取配置文件设置参数  `sysctl -p [/path/to/conf_file]`  

- (3) 查看所有生效参数  `sysctl -a`


## 内核常用参数

| 参数                                                         | 对应文件                                | 备注                                                         |
| ------------------------------------------------------------ | --------------------------------------- | ------------------------------------------------------------ |
| net.core.somaxconn = 4096                                    | /proc/sys/net/core/somaxconn            | 选项默认值是128，这个参数用于调节系统同时发起的tcp连接数，在高并发请求中，默认的值可能会导致连接超时或重传，因此，需要结合并发请求数来调节此值 |
| vm.swappiness = 1                                            | /proc/sys/vm/swappiness                 | 这个参数定义了系统对swap的使用倾向，centos7默认值为30，值越大表示越倾向于使用swap。可以设为0，这样做并不会禁止对swap的使用，只是最大限度地降低了使用swap的可能性 |
| net.ipv4.ip_forward = 1                                      | /proc/sys/net/ipv4/ip_forward           | 开启路由转发功能                                             |
| net.ipv4.icmp_echo_ignore_all = 1                            | /proc/sys/net/ipv4/icmp_echo_ignore_all | 禁ping                                                       |
| vm.drop_caches                                               | /proc/sys/vm/drop_caches                | 用来控制是否清空文件缓存：默认是0；1-清空页缓存；2-清空inode和目录树缓存；3-清空所有缓存 |
| fs.file-max = 1020000                                        | /proc/sys/fs/file-max                   | 系统级别的可打开文件句柄数                                   |
| ulimit -n                                                    | /etc/security/limits.conf               | 限制经过PAM模块认证的用户打开的文件句柄数：* soft nofile 65535         * hard nofile 65535 |
| net.ipv4.tcp_syncookies = 1                                  | /proc/sys/net/ipv4/tcp_syncookies       | 开启SYN Cookies，当SYN等待队列溢出时，启用cookies来处理，可以防范少量的SYN攻击，默认为0，表示关闭 |
| net.ipv4.tcp_tw_reuse = 1                                    | /proc/sys/net/ipv4/tcp_tw_reuse         | 允许将TIME_WAIT sockets重新用于新的TCP连接，默认为0，表示关闭 |
| net.ipv4.tcp_tw_recycle = 1                                  | /proc/sys/net/ipv4/*                    | 允许将TIME_WAIT sockets快速回收以便利用，默认为0，表示关闭，需要同时开启 net.ipv4.tcp_timestamps 才能生效 |
| net.ipv4.tcp_timestamps = 1                                  | /proc/sys/net/ipv4/*                    | 默认为1                                                      |
| net.ipv4.tcp_fin_timeout = 30                                | /proc/sys/net/ipv4/*                    | 表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间。默认是60s |
| net.ipv4.ip_local_port_range = 1024 65500                    | /proc/sys/net/ipv4/*                    | 表示用于向外连接的端口范围。缺省情况下很小：32768到61000，改为1024到65500 |
| net.ipv4.tcp_max_syn_backlog = 8192                          | /proc/sys/net/ipv4/*                    | 表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。 |
| net.ipv4.tcp_max_tw_buckets = 5000                           | /proc/sys/net/ipv4/*                    | 表示系统同时保持TIME_WAIT套接字的最大数量，如果超过这个数字，TIME_WAIT套接字将立刻被清除并打印警告信息。 |
| net.ipv4.ip_nonlocal_bind = 1                                | /proc/sys/net/ipv4/ip_nonlocal_bind     | 此参数表示是否允许服务绑定一个本机不存在的IP地址； 使用场景：有些服务需要依赖一个vip才能启动，但是此vip不在本机上，当vip飘移到本机上时才存在；但是服务又需要提前启动，例如haproxy,nginx等代理需要绑定vip时； 0：默认值，表示不允许服务绑定一个本机不存的地址 1：表示允许服务绑定一个本机不存在的地址 |
| vm.overcommit_memory = 1                                     |                                         | vm.overcommit_memory：表示系统允许内存的分配情况 0：默认值；     表示内核将检查是否有足够的可用内存供应用进程使用；     如果有足够的可用内存，内存申请允许；     否则，内存申请失败，并把错误返回给应用进程。 1：表示内核允许分配所有的物理内存，而不管当前的内存状态如何。redis要把此参数设为1； 2：     表示允许分配的内存为：物理内存*vm.overcommit_ratio+交换空间;      与参数vm.overcommit_ratio结合使用； |
| cat /proc/meminfo \| awk '{print $1,$2/1024 " Mb"}' \| grep "Commit" |                                         | 查看系统中可提交的内存和已经申请的内存：   CommitLimit：表示系统可分配的内存     Committed_AS：表示系统已经分配的内存 |
| kernel.msgmax                                                |                                         | 进程间的通信需要依靠内核来进行管理；是通过消息列队来传递消息； 以字节为单位，规定消息的单大值； 默认为65536，即64k； 此值不能超过kernel.msgmnb的值，msgmnb限定了消息队列的最大值； |
| kernel.msgmnb                                                |                                         | 以字节为单位，规定了一个消息队列的最大值； 默认值为：65536，即64k； |
| kernel.mni                                                   |                                         | 指定消息队列的最大个数；                                     |
| kernel.shmall                                                |                                         | 以**页**为单位，控制共享内存总量；Linux一个内存页大小为4kb； |
| kernel.shmmax                                                |                                         | 定义单个共享内存段的最大值;  shmmax 设置应该足够大，设置的过低可能会导致需要创建多个共享内存段； |
| kernel.shmmni                                                |                                         | 定义共享内存段的个数，默认为4096；                           |
| net.ipv4.tcp_rmem = 4096/87380/67108864  net.ipv4.tcp_wmem = 4096/65536/67108864 |                                         | 增加tcp缓冲区大小，tcp_rmem表示接受数据缓冲区范围，tcp_wmem表示发送数据缓冲区范围，单位Byte，最大64M |
| net.ipv4.tcp_retries2 = 5                                    |                                         | TCP失败重传次数,默认值15，意味着重传15次才彻底放弃，可减少到5，以尽早释放内核资源;在通讯过程中（已激活的sock），数据包发送失败后，内核要重试发送多少次后才决定放弃连接 |