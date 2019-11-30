<center><font face="黑体" color="grey" size="5" >MySQL集群</font></center>

# 一.MySQL主从复制

## 1.1 主从复制概念

### 1.1.1 主从复制原理

- MySQL主从复制原理如图1
![](png/2019-11-30-10-41-11.png)
<center><font face="黑体" color="grey" size="3" >MySQL主从复制原理</font></center>

- 如上图示，主从复制相关概念有:Master server(主服务器)、Slave server(从服务器)、
Binary logs(二进制日志)、Relay logs(中继日志)及相关的信息文件。

- 主服务器数据变动后，二进制日志记录下来，主服务器的Binlog Dump线程将二进制日志
发送给从服务器的I/O Thread。接着从服务器I/O线程将其写入中继日志Relay log。后面的
SQL Thread将中继日志应用到从服务器，执行相应的SQL语句生成同步数据。

### 1.1.2 二进制日志类型



### 1.1.3 主从复制所涉及的线程

- Master server
  - Binlog dump thread:进行主从复制时主服务器上启动的进程，用于发送二进制日志内容到从服务器，
  该进程可以在主服务器上执行`SHOW PROCESSLIST`命令看到，叫Binlog Dump线程如:`Command: Binlog Dump`。

```sql
  MariaDB [(none)]> SHOW PROCESSLIST\G
*************************** 1. row ***************************
      Id: 10
    User: root
    Host: localhost
      db: NULL
 Command: Query
    Time: 0
   State: NULL
    Info: show processlist
Progress: 0.000
*************************** 2. row ***************************
      Id: 202
    User: repluser1
    Host: 172.20.1.40:35346        # 从服务器1号
      db: NULL
 Command: Binlog Dump
    Time: 214
   State: Master has sent all binlog to slave; waiting for binlog to be updated
    Info: NULL
Progress: 0.000
*************************** 3. row ***************************
      Id: 204
    User: repluser1
    Host: 172.20.1.43:49098        # 从服务器2号
      db: NULL
 Command: Binlog Dump
    Time: 163
   State: Master has sent all binlog to slave; waiting for binlog to be updated
    Info: NULL
Progress: 0.000
3 rows in set (0.00 sec)
```

- Slaver server
  - I/O Thread:该线程为从服务器接收主服务器的二进制更新日志的线程，在从服务器上执行`START SLAVE`命令时其就
  会创建该线程，该线程连接到主服务器并请求主服务器发送二进制更新的部分日志。
  `(Master:Binlog Dump Thread ----> bnlog ----> Slave:I/O Thread)`
  - I/O线程状态可以使用`SHOW SLAVE STATUS`命令查看

```sql
MariaDB [(none)]> SHOW SLAVE STATUS\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 172.20.4.74
                  Master_User: repluser1
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mariadb-bin.000005
          Read_Master_Log_Pos: 245
               Relay_Log_File: slave-relay-bin.000005
                Relay_Log_Pos: 546
        Relay_Master_Log_File: mariadb-bin.000005
             Slave_IO_Running: Yes            # I/O Thread status
            Slave_SQL_Running: Yes
              ......略部分信息
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
1 row in set (0.00 sec)
```

- SQL Thread:从服务器创建一个SQL线程读取被I/O线程写入磁盘的中继日志Relay log,并执行其中记录的事务，生成数据。

- **每个主/从复制结构都涉及到三个线程:Master:Binlog dump thread;Slave:Slave I/O thread 和 Slave SQL thread**
**主服务器为每个从服务器创建一个Binlog dump thread;每个从服务器自己创建两线程。**
## 1.2 主从复制涉及的变量

### 1.2.1 Mater


### 1.2.2 Slave


### 1.2.3 Best Practices

## 1.3 监控和管理复制

## 1.4 检查数据一致性

## 1.5 二进制日志事件记录格式的选择

### 1.5.1 STATEMENT

### 1.5.2 ROW

## 1.6

Some Misconceptions About Replication
Replication is a cluster.
Standard asynchronous replication is not a synchronous cluster. Keep in mind that standard and semi-synchronous replication do not guarantee that the environments are serving the same dataset. This is different when using Percona XtraDB Cluster, where every server actually needs to process each change. If not, the impacted node is removed from the cluster. Asynchronous replication does not have this fail safe. It still accepts reads while in an inconsistent state.

Replication sounds perfect, I can use this as a manual failover solution.
Theoretically, the environments should be comparable. However, there are many parameters influencing the efficiency and consistency of the data transfer. As long as you use asynchronous replication, there is no guarantee that the transaction correctly took place. You can circumvent this by enhancing the durability of the configuration, but this comes at a performance cost. You can verify the consistency of your master and slaves using the  pt-table-checksum tool.

I have replication, so I actually don’t need backups.
Replication is a great solution for having an accessible copy of the dataset (e.g., reporting issues, read queries, generating backups). This is not a backup solution, however. Having an offsite backup provides you with the certainty that you can rebuild your environment in the case of any major disasters, user error or other reasons (remember the Bobby Tables comic). Some people use delayed slaves. However, even delayed slaves are not a replacement for proper disaster recovery procedures.

I have replication, so the environment will now load balance the transactions.
Although you’ve potentially improved the availability of your environment by having a secondary instance running with the same dataset, you still might need to point the read queries towards the slaves and the write queries to the master. You can use proxy tools, or define this functionality in your own application.

Replication will slow down my master significantly.
Replication has only minor performance impacts on your master. Peter Zaitsev has an interesting post on this here, which discusses the potential impact of slaves on the master. Keep in mind that writing to the binary log can potentially impact performance, especially if you have a lot of small transactions that are then dumped and received by multiple slaves.

There are, of course, many other parameters that might impact the performance of the actual master and slave setup.

# 二.MySQL读写分离

# 三.MySQL高可用

# 四.




CHANGE MASTER TO
MASTER_HOST='172.20.4.74',
MASTER_USER='repluser1',
MASTER_PASSWORD='stevenux',
MASTER_PORT=3306,
MASTER_LOG_FILE='mariadb-bin.000005', MASTER_LOG_POS=245;