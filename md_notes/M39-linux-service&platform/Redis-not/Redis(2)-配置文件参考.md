# Redis 配置文件参考

redis-5.0.7 配置文件翻译(<font face="黑体" color="red">**有错误欢迎留言指出**</font>)

```bash
################################## INCLUDES ###################################
################################## 文件包含  ###################################
# include /path/to/local.conf
# include /path/to/other.conf
#
################################## MODULES #####################################
################################## 模块加载 #####################################
# loadmodule /path/to/my_module.so
# loadmodule /path/to/other_module.so
#
################################## NETWORK #####################################
################################## 网络配置 #####################################
# bind 192.168.1.100 10.0.0.1
# bind 127.0.0.1 ::1
# bind 127.0.0.1
bind 0.0.0.0
    # 配置redis接收连接的监听地址，空格分隔多个地址

protected-mode yes
    # redis3.2 之后加入的新特性，默认开启。在没有设置bind IP和密码的时候redis只允许访问
    # 127.0.0.1:6379，远程访问将提示警告信息并拒绝远程访问

port 6379
    # redis-server监听连接的端口，如果配置为0，那么redis不监听TCP socket

tcp-backlog 511
    # TCP协议三次握手的时候redis-server端收到client ack确认号之后的队列个数。在单位时间
    # 内(比如1秒)连接数很多时，需要调高该数值。需要注意是该数值不会超过/proc/sys/net/core/somaxconn
    # 定义的值大小，如果需要调大，那么该内核参数也要调大。

timeout 0
    # 客户端和Redis服务端的连接超时时间，默认是0，表示永不超时。
    # timeout 5 表示客户端闲置5秒后redis会断开该链接

# unixsocket /tmp/redis.sock
# unixsocketperm 700
    # 指定监听的unix套接字，默认不监听unix套接字

tcp-keepalive 300
    # 用于保持TCP会话
    # Redis 3.2.1后的推荐配置为300

################################# GENERAL #####################################
################################# 常规配置 ####################################
daemonize no
    # 认情况下 redis 不作为守护进程运行。当redis作为守护进程运行的时候，其默认将PID文件
    # 写入/var/run/redis.pid 文件。

supervised no
    # 配置是否通过系统的管理服务upstart或者systemd来启动和管理Redis守护进程。
    # CentOS7 及以后都使用systemd
    # 可以配置如下选项：
        # supervised upstart - signal upstart by putting Redis into SIGSTOP mode
        # supervised systemd - signal systemd by writing READY=1 to $NOTIFY_SOCKET
        # supervised auto    - detect upstart or systemd method based on
        #                      UPSTART_JOB or NOTIFY_SOCKET environment variables

pidfile /var/run/redis_6379.pid
    # PID文件路径，Redis以守护进程启动时使用的PID文件，在启动时创建，在退出时删除。
    # 不指定该文件redis默认会创建在"/var/run/redis.pid"。如果redis无法穿件该PID文件
    # 也不会报错，redis还会正常启动工作

loglevel notice
    # 指定服务器输出日志的详细级别
    # 可以是以下值：
        # debug (很多信息，开发和测试使用)
        # verbose (很多极少使用到的有用信息，不如debug级别详细)
        # notice (细节差不多刚刚好，生产中这样配，懂？)
        # warning (只有很重要/要命的信息被记录输出)

logfile ""
    # 指定日志文件，空字符串表示强制redis输出日志到标准输出
    # 如果你将redis作为服务守护进程启动而未指定日志文件，那么日志将写入设备/dev/null

# syslog-enabled no
    # 该选项配置要不要将redis日志合并到system logger
# syslog-ident redis
    # 指定syslog标识
# syslog-facility local0
    # 指定syslog设备，必须为USER 或 LOCAL0-LOCAL7.

databases 16
    # 设置数据库个数，默认的数据库为DB 0 ，索引为0
    # 可以使用指令：SELECT <dbid>选择某个数据库
    # databases 16 表示数据库DB0-DB15

always-show-logo yes
    # 该配置指令配置是否在前台启动redis时向交互终端的标准输出设备写ASCII
    # 编码的redis logo

################################ SNAPSHOTTING  ################################
################################ RedisDB快照机制 ###############################
# save <seconds> <changes>
    # 将数据库保存在磁盘上，在一段时间内改变的键个数到达一定时间时触发保存
    # 注释save开头的行将停止数据库快照机制
    # save "" 该配置将删除以前配置的所有快照保存点
save 900 1
    # 900秒后如果有1个键(key)改变，就快照该数据库保存到磁盘
save 300 10
    # 300秒后如果有10个键(key)改变，就快照该数据库保存到磁盘
save 60 10000
    # 60秒后如果有10000个键(key)改变，就快照该数据库保存到磁盘

stop-writes-on-bgsave-error no
    # 配置后台保存(快照)出错时是否禁用 redis 写入操作
    # 默认情况下，如果redis开启了RDB快照机制(至少有一个保存点)并且最近一次的后台快照操作
    # 失败，就会禁用写操作。如果后台的保存进程又开始正常工作，那么redis又会允许写入操作
    # 如果已经通过其他机制良好的配置了redis数据持久策略，那么可以将该选项配置为no。这使得
    # redis在硬盘出问题或者遇到权限问题时任然能正常工作。

rdbcompression yes
    # 该配置项决定持久化数据到RDB文件时，是否压缩，"yes"为压缩，"no"则反之
    # 保存.rdb文件时使用LZF压缩字符串对象
    # 不压缩可以从保存进程得到一些CPU性能，但是推荐yes

rdbchecksum yes
    # 该配置决定是否使用CRC64校验RDB文件，默认使用
    # 版本5的RDB数据库文件末尾存放了该CRC64校验值，使用校验会使得RDB文件更不容易
    # 损坏，但是校验会在保存和加载RDB文件时损失10%的性能，如果最求最大化性能，可
    # 以设置为no禁用。
    # checksum 禁用时创建的RDB文件有一个为0的checksum值，告知加载代码跳过检查

dbfilename dump.rdb
    # 快照保存的文件名

dir ./
    # 快照文件保存路径，必须是文件夹路径，非文件路径
    # AOF文件也会被保存到此路径

################################# REPLICATION #################################
################################# 主从复制配置 #################################
#   +------------------+      +---------------+
#   |      Master      | ---> |    Replica    |
#   | (receive writes) |      |  (exact copy) |
#   +------------------+      +---------------+
# 1. Redis的主从复制是异步的，也可以将Master配置为当与其连接的从库少于一定数量时
#    停止接受写操作命令
# 2. Redis的从库可以在连接断开的一定时间内执行和主库的部分重同步，这个行为需要合适
#    的backlog大小配置
# 3. 主从的复制是自动进行的。

# replicaof <masterip> <masterport>
    # 该指令将该Redis实例变为配置的IP和端口指向的库的从库

# masterauth <master-password>
    # 设置连接密码

replica-serve-stale-data yes
    # 该配置决定从库和主库断开连接后，从库应对请求的行为：
    # "yes" 表示，从库继续接受客户端请求，这可能会返给客户端一些过时数据
    # "no" 表示，除了INFO, replicaOF, AUTH, PING, SHUTDOWN, REPLCONF, ROLE, CONFIG,
    #               SUBSCRIBE, UNSUBSCRIBE, PSUBSCRIBE, PUNSUBSCRIBE, PUBLISH, PUBSUB,
    #               COMMAND, POST, HOST: and LATENCY等命令会响应外，其它的请求都回应一个
    #               错误"SYNC with master in progress"

replica-read-only yes
    # 该选项设置从库是否只读

repl-diskless-sync no
# -------------------------------------------------------
# WARNING: DISKLESS REPLICATION IS EXPERIMENTAL CURRENTLY
# 注意：无盘复制目前处于试验阶段
# -------------------------------------------------------
    # 该选择配置复制时同步(SYNC)的策略：写disk或者写socket
    # 新的从库或者处于重新连接的从库无法继续进行主从复制，只会收到数据差异信息。此时
    # 从库需要和主库做全量同步。主库redis会将内存中dump出新的RDB文件，并发送该从库。
    # 有两种方式发送：
        # 1) Disk-backed(yes): Redis master 创建一个新的进程将RDB文件写入到磁盘。之后
        #    Redis主进程以增量方式传输该从库。
        # 2) Diskless(no): Redis master 创建一个新进程直接dump RDB到slave的socket，不经
        #    过主进程，不经过硬盘
    # 基于硬盘的话，RDB文件创建后，一旦创建完毕，可以同时服务更多的slave，但是基于socket
    # 的话， 新slave连接到master之后得逐个同步数据。在较慢并且网络较快的时候，可以用
    # diskless(yes),否则使用磁盘(no)`

repl-diskless-sync-delay 5
    # 复制的延迟时间，设置0为关闭，在延迟时间内连接的新客户端，会一起通过disk方式同步数据，
    # 但是一旦复制开始还没有结束之前，master节点不会再接收新slave的复制请求，直到下一次
    # 同步开始。

# repl-ping-replica-period 10
    # 该选项使得slave根据master指定的时间进行周期性的PING监测

# repl-timeout 60
    # 该复制超时配置指令设置以下情况的超时(必须大于repl-ping-replica-period):
    # 1) 从库角度，在SYNC时(同步期间)的批量文件传输I/O超时
    # 2) 从库角度，主库超时(数据传输超时，ping超时)
    # 3) 主库角度，从库的复制超时(REPLCONF ACK pings).

repl-disable-tcp-nodelay no
    # 在socket的复制同步模式下是否在slave套接字发送SYNC之后禁用 TCP_NODELAY
        # "yes" redis会使用较少量的TCP包和带宽向从站发送数据。但这会导致在从站增加一点数据
        # 的时延。Linux内核默认配置情况下最多40毫秒的延时。
        # "no" 从站的数据延时不会那么多，但备份需要的带宽相对较多。默认情况下追求最小延迟
        # 设置为no，但在高负载情况下或者在主从站距离比较远的情况下，把它切换为yes更好。

# repl-backlog-size 1mb
    # 设置复制的backlog大小，backlog是在从库断开连接后累加复制数据的缓冲，所以在某个从库
    # 断开连接重新连接后，通常只需部分同步，而不需要完全同步。
    # backlog越大，允许从库断开连接的实际越长而不会丢失数据(重连后进行部分同步)

# repl-backlog-ttl 3600
    # 该选项配置master在多久时间内没有slave连接就清空backlog缓冲
    # 计时从最后一个slave断开开始，值为0表示不释放buffer

replica-priority 100
    # 当master不可用，Sentinel会根据slave的优先级选举一个master，最低的优先级的slave会
    # 被选为master 。而配置成0，永远不会被选举

# min-replicas-to-write 3
# min-replicas-max-lag 10
    # 上面两个配置项表示：存在至少3个活动的从库连接并且从库的延迟小于或等于10秒，就让主库
    # master停止接收写请求，将写请求给从库处理。设置为0则不启用该功能。

# replica-announce-ip 5.5.5.5
# replica-announce-port 1234


################################## SECURITY ###################################
################################## 安全配置 ###################################
# requirepass foobared
    # 配置redis客户端连接密码，需要客户端连接后在处理其他命令前先执行UTH <PASSWORD>

# rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52
    # 重命名命令，可以避免将危险的命令暴露给外部，也可保证安全性。
    # rename-command CONFIG "" 表示禁用CONFIG指令

################################### CLIENTS ####################################
# maxclients 10000
    # 设置同时允许连接的客户端的最大数目

############################## MEMORY MANAGEMENT ################################
############################## 内存管理配置       ################################
# maxmemory <bytes>
    # 配置Redis的内存使用上限，redis最大内存，单位为字节，8G内存配置时指定的数值
    # 为：8*1024*1024*1024(Byte)，需要注意的是slave的输出缓冲区是不计算在maxmemory内的。
    # Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期
    # 的Key。当此方法处理后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读
    # 取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区。


# maxmemory-policy noeviction
    # 当内存达到maxmemory指定的值时，Redis选择移除什么来释放内存
        # volatile-lru    -> 使用接近LRU的算法回收设置有过期时间的KEY。
        # allkeys-lru     -> 使用接近LRU的算法回收任何KEY。
        # volatile-lfu    -> 使用接近LFU的算法回收设置有过期时间的KEY。
        # allkeys-lfu     -> Evict any key using approximated LFU.
        # volatile-random -> 随机移除设置有过期时间的KEY。
        # allkeys-random  -> 随机移除任何KEY。
        # volatile-ttl    -> 移除即将过期的KEY。(minor TTL)
        # noeviction      -> 不移除任何KEY，只对读操作返回一个错误。
            # LRU means Least Recently Used-最近最少使用算法
            # LFU means Least Frequently Used-最近最频繁使用算法

# maxmemory-samples 5
    # 由于LRU, LFU and volatile-ttl等算法都是使用近似随机的算法实现的，所以不是很
    # 准确。该选项用来在性能和准确性上做平衡。默认Redis会检查5个KEY然后选择一个最近
    # 最少使用的KEY释放。简单的说就是算法取样的大小。
    # 取3个快不准，取5个差不多，取10个准不快 (懂我意思吗？)

# replica-ignore-maxmemory yes
    # Redis 5开始，从库会忽略最大的内存配置项。KEY的回收由master库发送DEL指令到从库
    # 完成，就如同master回收自己的KEY一样。

############################# LAZY FREEING ####################################
############################# 删除KEY回收内存的机制-LAZY FREEING ##############
# Redis有两种删除KEY的原语。一个是指令DEL，是一种阻塞删除对象的机制，也就是说使用DEL
# 时server会停止处理新的命令，以同步的方式来回收与删除的对象相关的内存。
# 另一种非阻塞删除对象的原语如：FLUSHALL和FLUSHDB指令的UNLINK(非阻塞删除)和ASYNC。
# 这些指令会使用一个新的线程在后台回收内存。
# 默认是以阻塞的方式删除对象并回收内存，但是也可以配置为非阻塞的方式。如下:

lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no

############################## APPEND ONLY MODE ###############################
############################## 数据持久化策略：只追加模式 #######################
# Append Only File是除了RDB数据持久化的另一个方案，比RDB更加可靠。RBD和AOF策略可以
# 同时打开。
appendonly no
appendfilename "appendonly.aof"
    # 是否开启AOF数据持久化特性，指定AOF文件名。

# appendfsync always
appendfsync everysec
# appendfsync no
    # 该配置使用了fsync()系统调用通知OS将输出缓冲的数据立即写到磁盘。某些OS会直接写到
    # 磁盘，但是另一些则只会假模假式的ASAP。
    # no       表示不执行fsync，由操作系统自己决定何时将数据同步到磁盘，速度最快。
    # always   表示每次写入只追加日志都执行fsync，以保证数据同步到磁盘，慢安全。
    # everysec 表示每秒执行一次fsync，可能会导致丢失这1s数据。

no-appendfsync-on-rewrite no
    # 当AOF的fsync策略被设置为always或者everysec时，会有一个后台进程(后台BGSAVE或者
    # BGREWRITEAOF)进行频繁的I/O 操作，在某些Linux版本的内核设置中，这种情况会导致
    # Redis在调用fsync()时被阻塞时间过长。Linux的默认fsync策略是30秒，如果为"yes"可能
    # 丢失30秒数据。
    # 为了缓解以上问题，使用该指令来阻止fsync()被Redis主进程调用(在BGSAVE或者BGREWRITEAOF
    # 进行时)。如果有延迟问题，则可以设置为"yes"，否则使用默认的"no"。

auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
    # 上面选项控制在AOF文件大小增长到一定程度后调用BGREWRITEAOF自动重写AOF日志文件，
    # Redis会记住最近一次重写后AOF文件的大小(如果自Redis重启以来，AOF文件未被重写过，
    # 那么Redis会记住Redis启动时的大小)，之后Redis会将该值与当前的AOF文件大小作比较，
    # 如果当前的AOF文件增大幅度超过指令指定的百分比，则触发重写。另外，需要指定一个
    # 允许重写的最小AOF文件大小值，避免在AOF文件很小时频繁重写。
    # 指定一个为0的百分比则禁用该特性。

aof-load-truncated yes
    # 该选项控制在某些原因下AOF文件尾部有数据被截断时Redis的行为
    # 问题：在Redis运行的OS突然崩溃或者挂载EXT4文件系统没有指定data=ordered挂载选项时，
    #       在Redis启动过程中，AOF文件被加载进内存时可能会发现被截断过的AOF文件(数据缺失)，
    #       当然，如果Redis自身崩溃或者拒绝启动，但是OS正常运行，那就不会出现此问题。
    # 出现以上情况后，Redis在启动时可以抛出错误并退出或者加载尽可能多的数据(当找到被截断的
    # AOF文件时)。
    # 选项：aof-load-truncated yes 表示Redis会加载一个截断的AOF文件并启动，然后输出一段
    # 日志来通知用户该事件。aof-load-truncated no 表示Redis放弃启动并抛出错误，此时用户
    # 需要使用"redis-check-aof"工具修复AOF文件后才能正常启动Redis。

aof-use-rdb-preamble yes
    # 是否开启Redis4.0新增的RDB-AOF混合持久化格式，当该选项为yes时，AOF文件由两节组成：
    #   [RDB file][AOF tail]
    # 这样可以兼具RDB和AOF特性，快速重写AOF和快速载入AOF文件。在Redis启动载入AOF时
    # 会先载入带有"REDIS"前缀的RDB文件内容，再载入后面的AOF格式文件内容。

################################ LUA SCRIPTING  ###############################
lua-time-limit 5000
    # 限制lua脚本的执行时间，单位为毫秒(milliseconds)。如果脚本运行到达最大的执行时间
    # 限制，则Redis会记录一条日志并返回给查询语句一个错误。
    # 当一个脚本超过了最大执行时间限制。则只有SCRIPT KILL和SHUTDOWN NOSAVE两条命名可以使用。
    # 第一个可以结束没有调写命令的脚本。
    # 要是脚本已经调用了写命令，则只能用第二个命令关闭Redis服务。

################################ REDIS CLUSTER ###############################
################################ Redis 集群配置 ###############################
# Redis实例不能为Redis集群的节点，除非作为节点启动。为了以集群节点启动Redis实例，可以
# 取消下面的集群配置，并进行相关配置。

# cluster-enabled yes
    # 使用集群

# cluster-config-file nodes-6379.conf
    # 每个集群节点都有一个集群配置文件。该配置文件由节点自己生成和更新，不能手动更改。
    # 每个集群节点都需要一个单独的不同的配置文件。确保运行在同一个系统的Redis节点实例
    # 的配置文件名不同。

# cluster-node-timeout 15000
    # 集群中的节点最长的不可达时间，超过该时间不可达表示该节点死了，死了，死了...

# cluster-replica-validity-factor 10
    # Master出故障后死了，在进行故障转移的时候，全部slave node都会请求申请为master node，
    # 但是有某slave(最低优先级)可能与master断开连接一段时间了，导致数据过于陈旧，这样的
    # slave不应该被提升为master。该参数用来判断slave的数据新旧程度(与Master数据的一致程度)。
    # 该选项的值越大代表可以允许数据更旧的slave在故障转移中转换为master，防止亦然。
    # 默认是10

# cluster-migration-barrier 1
    # "集群迁移屏障"---在Redis集群中，某个主节点发生故障时至少需要有一定数量的正常工作的
    # slave节点，此时Redis集群的复制实例(slave)才会转移为Master。该数量就叫"集群迁移屏障"
    # 该值反映了在Redis集群中你想要你的每个Master有几个slave。

# cluster-require-full-coverage yes
    # 集群处理请求需要槽位全部覆盖(可用)，如果一个主库宕机且没有备库就会出现集群槽位不全，
    # "yes" redis集群槽位验证不全就不再对外提供服务。"no" 可以继续使用但是会出现查询数据
    # 查不到的情况(因为有数据丢失)。不建议打开该配置，这样会造成分区的时候，小分区的master
    # 一直在接受写请求，而造成很长时间数据不一致。

# cluster-replica-no-failover no
    # 该选项配置是否开启正常的集群故障迁移，yes为禁止故障迁移

########################## CLUSTER DOCKER/NAT support  ########################
########################## 集群对Docker/NAT的支持       ########################

# 在一些特定的部署情况下，Redis集群的节点地址发现会失效，原因是进行了NAT地址转换或者
# 进行了端口转发（典型的场景是Docker和其他的容器部署时）。

# 为了让Redis能够在这些环境下正常工作，使得每个节点知道自己的公共地址的静态配置就需要
# 提供。下面的两个选项就是提供这种配置的：
#
# * cluster-announce-ip
# * cluster-announce-port
# * cluster-announce-bus-port
#
# 上面的配置分别指出该节点的地址，客户端端口和集群消息总线的端口。该消息被发布在
# 总线报文的头部，以便以其它节点能够正确的映射发布该消息的节点的地址。
#
# 如果上面的配置未使用，那么常规的Redis集群的自动检测将会被使用。
#
# Example:
#
# cluster-announce-ip 10.1.1.5
# cluster-announce-port 6379
# cluster-announce-bus-port 6380

################################## SLOW LOG ###################################
################################## 慢日志   ###################################
# Redis慢日志系统用来记录超过指定的执行时间的查询操作。该执行时间不包括I/O操作(如与客户端
# 的交流信息、发送响应给客户端)，仅只执行命令的时间(该情况下只执行命令相关的线程被阻塞无法
# 提供其它请求的服务)。

# 下面的两个选项用来配置慢日志：

slowlog-log-slower-than 10000  # (10000 微秒 = 10 毫秒 = 0.1秒)
    # 指定执行时间超过多久的查询可以被日志记录，以微妙(microseconds)为单位。配置一个
    # 负的整数禁用慢日志，配置0表示日志将记录每一个命令。
    # 单位：1000000 microsec(微妙) = 1000 millisec(毫秒) = 1 sec(秒)

slowlog-max-len 128
    # 指定慢日志的记录文件大小，该值无上限。过大吃内存，使用 SLOWLOG RESET 清除慢日志文件。

################################ LATENCY MONITOR ##############################
################################ 延迟监控        ##############################
latency-monitor-threshold 0
    # 该选项用于配置Redis的延迟监控系统，该系统会在Redis运行时取样不同的操作。该配置
    # 主要配合慢日志系统使用，当"slowlog-log-slower-than 0"时，即记录任何命令的日志时，
    # 延迟监控会自动禁用。建议不开启。

############################# EVENT NOTIFICATION ##############################
############################# 事件通知           ##############################
# Redis可以通知Pub/Sub客户端(发布/订阅客户端)关于在键空间(key space)发生的事件。
#
# 例如：如果keyspace事件通知开启情况下，某个客户端在DB0上的"foo"键上执行了一个DEL命令
# 那么两条消息将会通过发布/订阅机制发布出来：
# PUBLISH __keyspace@0__:foo del
# PUBLISH __keyevent@0__:del foo
#
# 可以用单个字符表示需要记录和发布什么操作：
#  K     Keyspace events, published with __keyspace@<db>__ prefix.
#  E     Keyevent events, published with __keyevent@<db>__ prefix.
#  g     Generic commands (non-type specific) like DEL, EXPIRE, RENAME, ...
#  $     String commands
#  l     List commands
#  s     Set commands
#  h     Hash commands
#  z     Sorted set commands
#  x     Expired events (events generated every time a key expires)
#  e     Evicted events (events generated when a key is evicted for maxmemory)
#  A     Alias for g$lshzxe, so that the "AKE" string means all the events.

# 如： notify-keyspace-events Elg 表示使能列表和常规的命令事件通知
# 输入的参数中至少要有一个 K 或者 E，否则的话，不管其余的参数是什么，都不会有任何通知被分发。

notify-keyspace-events ""

############################### ADVANCED CONFIG ###############################
############################### 高级配置        ###############################
hash-max-ziplist-entries 512
    # hash类型的数据结构在编码上可以使用ziplist和hashtable
    # ziplist的特点就是文件存储(或者内存存储)所需的空间较小,在内容较小时,性能和hashtable
    # 几乎一样。因此redis对hash类型默认采取ziplist。如果hash中条目的条目个数或者value长度
    # 达到阀值,将会被重构为hashtable。这个参数指的是ziplist中允许存储的最大条目个数，默认
    # 为512。

hash-max-ziplist-value 64
    # ziplist数据结构中允许每个条目的value值最大字节数，默认为64，建议为1024

list-max-ziplist-size -2
    # 在Redis中为了节约内存空间，list列表也使用了特殊的编码方式。
    # 该配置项的值当取正时，表示按照列表中数据项个数来限定每个内部列表节点长度。当该
    # 参数配置成100时，表示每个列表节点的list最多包含100个数据项。
    # 当取负值的时候，表示按照占用字节数来限定每个列表节点上的列表长度。这时，它只能
    # 取-1到-5这五个值，每个值含义如下：
        # -5: 每个quicklist节点上的ziplist大小不能超过64 Kb。（注：1kb => 1024 bytes）
        # -4: 每个quicklist节点上的ziplist大小不能超过32 Kb。
        # -3: 每个quicklist节点上的ziplist大小不能超过16 Kb。
        # -2: 每个quicklist节点上的ziplist大小不能超过8 Kb。（-2或-1是Redis推荐值）
        # -1: 每个quicklist节点上的ziplist大小不能超过4 Kb。

list-compress-depth 0
    # Redis的列表是可以被压缩后再存入内存的，该配置项规定quicklist双向链表两端不被压缩的
    # 节点个数(压缩深度)。
        # 0: 表示不压缩ziplist列表。
        # 1: 深度为1表示在第一个ziplist后才压缩quicklist中的ziplist列表。
        #    也就是说这里的头和尾都未压缩: [head]->node->node->...->node->[tail]
        #    实际上[head]和[tail]永远不会被压缩，这是为了能够快速执行PUSH/POP操作。
        # 2: [head]->[next]->node->node->...->node->[prev]->[tail]
        #    此时表示只压缩 head 或 head->next 或 tail->prev 或 tail,压缩它们之间的其它
        #    节点。
        # 3: [head]->[next]->[next]->node->node->...->node->[prev]->[prev]->[tail]
        # 以此类推...

set-max-intset-entries 512
    # Redis的集合类型在其内容(字符串)恰巧为不超过64比特大小范围内保存的十进制数时，其
    # 使用了一种特殊的编码方式。该配置表示数据量小于等于512时使用intset集合，大于512
    # 时使用set集合

zset-max-ziplist-entries 128 # ziplist长度
zset-max-ziplist-value 64 # 有序集合的元素个数
    # 同样，在Redis中有序集合也使用特殊的编码方式以节省内存空间，当ziplist的长度和有序集合
    # 中的元素小于上面的配置值时才使用该编码。

hll-sparse-max-bytes 3000
    # 该值划分HyperLogLog使用的数据结构，该配置表示当HyperLogLog的大小小于或等于3000时使用
    # 稀疏(sparce)数据结构，超过该值使用密集(dence)的数据结构。推荐的值为3000。

stream-node-max-bytes 4096
stream-node-max-entries 100
    # 没看懂

activerehashing yes
    # Redis在每100毫秒时间内1毫秒的CPU时间来对redis的hash表进行重新hash，可以降低内存的使用。
    # 用场景中有非常严格的实时性需要时，不能够接受Redis时不时的对请求有2毫秒的延迟的话，no。
    # 如果没有这么严格的实时性要求，可以设置为yes，以便能够尽可能快的释放内存。

# client-output-buffer-limit <class> <hard limit> <soft limit> <soft seconds>
# class：normal | replica | pubsub
client-output-buffer-limit normal 0 0 0
    # 该配置项用于对客户端输出缓冲进行限制，可以强迫那些从服务器读取数据非常慢的客户端断开连接，
    # 对于normal client，第一个0表示取消hard limit，第二个0和第三个0表示取消soft limit
    # normal client默认取消限制。normal client包括MONITER client。
client-output-buffer-limit replica 256mb 64mb 60
    # 对于slave client，如果client-output-buffer一旦超过256mb，又或者超过64mb持续60秒，
    # 那么服务器就会立即断开客户端连接
client-output-buffer-limit pubsub 32mb 8mb 60
    # 对于pubsub client，如果client-output-buffer一旦超过32mb，又或者超过8mb持续60秒，那么服
    # 务器就会立即断开客户端连接。

# client-query-buffer-limit 1gb
    # 客户端的查询缓冲会积累新的命令。该选项配置查询缓冲的大小。

# proto-max-bulk-len 512mb
    # 在Redis协议中，表示单个字符串的元素大小通常被限制在512MB内。

hz 10
    # 该值代表Redis执行任务的频率(Hz)，该值为10表示每秒执行10个任务。
    # Redis会调用一个内部函数来执行多个后台任务，如在客户端超时时关闭连接，清除未被使用的
    # 的过期键等。
    # 提高该值会使得Redis在空闲时更消耗CPU资源，但是在同时有大量KEY过期时Redsi响应会更快。
    # 值在1~500之间，使用100可以获得超低的延迟，但是这样的情况极少。

dynamic-hz yes
    # 该选项用于配置hz的值是否跟随连接的客户端个数动态变化，而实际配置的hz值则作为参考基线。
    # 这种情况下，空闲的Redis进程将使用更少的CPU资源，一个高负载的redis也会更快响应。

aof-rewrite-incremental-fsync yes
    # 当一个子进程重写AOF文件时，如果该配置项为yes，则AOF文件将会系统会在AOF文件每产生32MB
    # 时执行一次fsync。这对于把文件写入磁盘是有帮助的，可以避免过大的延迟峰值。

rdb-save-incremental-fsync yes
    # 同前一选项，针对RDB文件
#
# lfu-log-factor 10
# lfu-decay-time 1

########################### ACTIVE DEFRAGMENTATION #######################
########################### 主动碎片整理            #######################
# WARNING THIS FEATURE IS EXPERIMENTAL.
# 该特性处于测试阶段，但是通过了生产中和压力测试。
#
# What is active defragmentation?
# -------------------------------
#
# Active (online) defragmentation allows a Redis server to compact the
# spaces left between small allocations and deallocations of data in memory,
# thus allowing to reclaim back memory.
#
# Fragmentation is a natural process that happens with every allocator (but
# less so with Jemalloc, fortunately) and certain workloads. Normally a server
# restart is needed in order to lower the fragmentation, or at least to flush
# away all the data and create it again. However thanks to this feature
# implemented by Oran Agra for Redis 4.0 this process can happen at runtime
# in an "hot" way, while the server is running.
#
# Basically when the fragmentation is over a certain level (see the
# configuration options below) Redis will start to create new copies of the
# values in contiguous memory regions by exploiting certain specific Jemalloc
# features (in order to understand if an allocation is causing fragmentation
# and to allocate it in a better place), and at the same time, will release the
# old copies of the data. This process, repeated incrementally for all the keys
# will cause the fragmentation to drop back to normal values.
#
# 重要：
#
# 1. This feature is disabled by default, and only works if you compiled Redis
#    to use the copy of Jemalloc we ship with the source code of Redis.
#    This is the default with Linux builds.
#
# 2. You never need to enable this feature if you don't have fragmentation
#    issues.
#
# 3. Once you experience fragmentation, you can enable this feature when
#    needed with the command "CONFIG SET activedefrag yes".
#

# 配置：
# activedefrag yes
# active-defrag-ignore-bytes 100mb
# active-defrag-threshold-lower 10
# active-defrag-threshold-upper 100
# active-defrag-cycle-min 5
# active-defrag-cycle-max 75
# active-defrag-max-scan-fields 1000
```
