<center><font face="黑体" color="grey" size="5" >MySQL备份和恢复</font></center>

# 一.备份和恢复概述

## 1.1 为何备份?

- 灾难恢复
当出现严重的硬件故障、或者某个无耻的软件错误损坏了关键数据，或者服务器抽风，突然数据无法读取；
又或者黑客攻击、人员无操作等不幸发生时，此时如果没有备份数据，那就完蛋了。

- 审计
有时，有需要知道数据在过去的某个时间点是怎样的，例如：有人发现你的软件中的某个BUG，需要知道
代码在过去干了些啥(总有些时候你的软件仅仅有版本控制是不够的)

- 测试
在实际产生的数据上测试往往要频繁的将最新的产品数据放到测试服务器上，一个非常方便的做法是周期性
的使用最新的产品的数据备份恢复到测试服务器上。

- 某些人总是改变想法
你会惊讶于某些人删除了数据后反悔的速度有多快。

## 1.2 备份什么?

- 首要的是数据
对于MySQL来说，日志即代表了数据，包括：二进制日志(binary log)和InnoDB的事务日志(transaction log)

- 代码
目前的数据库产品如MySQL，都会存有大量的代码，如触发器和存储过程；备份mysql数据库可以备份大
部分触发器和存储过程，因为大部分的类似的代码都被存在系统数据库mysql中；但是没法独立的恢复
某个表，因为该表的某些“数据”(如存储过程)实际上存放于mysql数据库中。

下面展示了存储过程sp_testlog关联的数据存放在hellodb数据库的testlog表；而sp_testlog自身的
定义则被存放在mysql数据库的proc表

```sql
MariaDB [mysql]> USE mysql; SHOW TABLES;
Database changed
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| columns_priv              |
| db                        |
| event                     |
| func                      |
| general_log               |
| help_category             |
| help_keyword              |
| help_relation             |
| help_topic                |
| host                      |
| ndb_binlog_index          |
| plugin                    |
| proc                      |   # 此表存放sp_testlog存储过程
| procs_priv                |
| proxies_priv              |
| servers                   |
| slow_log                  |
| tables_priv               |
| time_zone                 |
| time_zone_leap_second     |
| time_zone_name            |
| time_zone_transition      |
| time_zone_transition_type |
| user                      |
+---------------------------+
24 rows in set (0.00 sec)

MariaDB [mysql]> SHOW PROCEDURE STATUS\G
*************************** 1. row ***************************
                  Db: hellodb       # sp_testlog存储过程关联的数据表
                Name: sp_testlog    # sp_testlog存储过程
                Type: PROCEDURE
             Definer: root@localhost
            Modified: 2019-11-27 08:47:42
             Created: 2019-11-27 08:47:42
       Security_type: DEFINER
             Comment: 
character_set_client: utf8
collation_connection: utf8_general_ci
  Database Collation: utf8_general_ci
1 row in set (0.00 sec)

MariaDB [mysql]> USE hellodb; SHOW tables;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
+-------------------+
| Tables_in_hellodb |
+-------------------+
| classes           |
| coc               |
| courses           |
| scores            |
| students          |
| testlog           |           # sp_testlog存储过程关联的数据表
+-------------------+
6 rows in set (0.00 sec)


MariaDB [mysql]> SELECT * FROM proc\G
*************************** 1. row ***************************
                  db: hellodb
                name: sp_testlog
                type: PROCEDURE
       specific_name: sp_testlog
            language: SQL
     sql_data_access: CONTAINS_SQL
    is_deterministic: NO
       security_type: DEFINER
          param_list: 
             returns: 
                body:               # 存储过程定义
begin;
declare i int;
set i = 1; 
while i <= 100000 
do  insert into testlog(name,age) values (concat('wang',i),i); 
set i = i +1; 
end while; 
end
...
1 row in set (0.00 sec)

```

- 数据复制相关的配置文件
如果涉及到主从复制的数据库备份和恢复(实际生产环境常见)，那最好把涉及到的配置文件全部包括到
备份计划中；如：二进制日志，中继日志，日志索引文件和.info文件等。

- 服务器配置文件
如果可能必须从严重的灾难恢复，需要配置一个全新的服务器，那最好连服务器配置文件备份。

- 和服务器紧密相关的系统配置文件
如涉及到备份计划的cron事务，用户和组配置，管理性脚本和sudo规则等。

## 1.3 备份要考虑哪些因素？

### 1.3.1  恢复点目标(RPO:recovery point objective)和恢复时间目标(RTO:recovery time objective)

- 在没有严重后果的情况下容忍多少数据丢失？
- 数据恢复时速度要多快才行？数据库不可访问时，什么时间范围内可以接受？用户能接受的时间长短？
- 需要恢复什么？
整个服务器？单个数据库？单张表？或者单个语句和事务？

### 1.3.2 备份策略

- 温备时加锁多久？

- 备份产生的负载服务器在该时段是否能够承载？

- 备份脚本的严格性？

### 1.3.3 备份和恢复的挑战

- 某个人可以计划，设计，实施备份；但是灾难恢复时未必是同一个人？

- 执着于备份，未进行恢复测试和演练？

## 1.4  备份的类型?

### 1.4.1 完全备份

完全备份：整个数据集,包括配置文件，全部数据库，全部日志。

### 1.4.2 部分备份

部分备份：只备份数据子集，如部分库或表或者某些SQL语句

### 1.4.3 增量备份和差异备份

增量备份:仅备份最近一次完全备份或增量备份（如果存在增量）以来变化的数据，备份较快，还原复杂
差异备份:仅备份最近一次完全备份以来变化的数据，备份较慢，还原简单
![](png/2019-11-28-16-33-07.png)
<center><font face="黑体" color="grey" size="2" >上:增量 下:差异</font></center>

### 1.4.4 冷备 温备 热备

冷备:对数据库的读、写操作均不可进行,相当于停数据库；完全停业务；也叫离线备份
温备:对数据库的读操作可执行,但写操作不可执行;影响业务
热备:对数据库的读、写操作均可执行;不影响业务

InnoDB：支持以上三种备份方式
MyISAM：只支持冷备和温备，不支持热备

### 1.4.5 物理备份

- 直接复制数据文件进行备份，与存储引擎有关，占用较多的空间，速度快
- 物理备份的优势：
1.备份操作简单，直接拷贝需要备份的文件到备份服务器
2.恢复物理备份亦简单，MyISAM的存储引擎直接放到相应的位置；InnoDB的存储引擎则需要停止MySQL
服务和其他的简单步骤。
3.InnoDB和MyISAM的数据库的物理备份可以跨平台、跨操作系统和跨MySQL版本兼容(逻辑备份亦可以)。
4.恢复物理备份的时间极短，因为MySQL服务器不用执行任何SQL语句或者构建索引；相比逻辑备份来说，
比较可怕的一点就是无法预估逻辑备份恢复的时间。
- 物理备份的劣势：
1.基于InnoDB数据库的物理备份文件往往远大于相对应的逻辑备份文件。InnoDB的表空间有很多未使用的
磁盘空间，有部分空间用来实现其他功能而不是存储数据(如：插入缓存，回滚段空间等)
2.由于文件名大小写敏感和不同的系统浮点数格式不一样等问题，物理备份也不是能够跨所有平台和系统。

### 1.4.6 逻辑备份

从数据库中“导出”数据另存而进行的备份，与存储引擎无关，占用空间少，速度慢，可能丢失精度

- 逻辑备份的优势:
1.逻辑备份是普通的文本文件，可以编辑查看修改。如使用grep和sed等工具处理后再恢复，或者在不
恢复的情况下查看数据。
2.还原方便，简单的使用管道传给mysql或使用mysqlimport命令就可以。
3.可以远程通过网络恢复数据。
4.配合mysqldump等恢复工具，可以非常灵活。
5.几乎与存储引擎无关的。可以备份InnoDB的数据表还原到使用MyISAM引擎的数据库中，几乎不要额外的工作。

- 逻辑备份的缺陷:
1.备份时，占用额外的服务器资源来产生备份文件。
2.逻辑备份有时会比物理文件大很多，使用压缩又会消耗CPU资源。
3.还原逻辑备份时需要MySQL解释执行SQL语句，转换为存储格式，并且重建索引；很慢。

# 二.mysqldump备份工具

## 2.1 mysqldump

- mysqldump为mysql的客户端工具之一，用于实现逻辑备份功能；其通过产生可执行的SQL语句来备份一个
或多个数据库；mysqldump也可以产生CSV或者XML格式的文件。

## 2.2 用法及选项

```bash
mysqldump [OPTIONS] database [tables]
mysqldump [OPTIONS] –B DB1 [DB2 DB3...]
mysqldump [OPTIONS] –A [OPTIONS]

-A, --all-databases           #备份所有数据库，含create database
-B, --databases db_name…      #指定备份的数据库，包括create database语句
-E, --events                  #备份相关的所有event scheduler
-R, --routines                #备份所有存储过程和自定义函数
--triggers                    #备份表相关触发器，默认启用,用--skip-triggers，不备份触发器
--default-character-set=utf8  #指定字符集
--master-data[=#]             #此选项须启用二进制日志
                                 # 1：所备份的数据之前加一条记录为CHANGE MASTER TO语句，非注释，不指定#，默认为1
                                 # 2：记录为注释的CHANGE MASTER TO语句
                                 # 此选项会自动关闭--lock-tables功能，自动打开-x | --lock-all-tables功能（除非开启--single-transaction）
-F, --flush-logs              #备份前滚动日志，锁定表完成后，执行flush logs命令,生成新的二进制日志文
                               # 件，配合-A 或 -B 选项时，会导致刷新多次数据库。建议在同一时刻执行转储和
                               # 日志刷新，可通过和--single-transaction或-x，--master-data 一起使用实现，
                               # 此时只刷新一次二进制日志
--compact                    #去掉注释，适合调试，生产不使用
-d, --no-data                #只备份表结构
-t, --no-create-info         #只备份数据,不备份create table 
-n,--no-create-db            #不备份create database，可被-A或-B覆盖
--flush-privileges           #备份mysql或相关时需要使用
-f, --force                  #忽略SQL错误，继续执行
--hex-blob                   #使用十六进制符号转储二进制列，当有包括BINARY， VARBINARY，BLOB，BIT的数据类型的列时使用，避免乱码
-q, --quick                  #不缓存查询，直接输出，加快备份速度
```

## 2.3 备份示例

- 

# 三.xtrabackup备份工具

