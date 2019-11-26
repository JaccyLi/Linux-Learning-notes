<center><font face="黑体" color="grey" size="5" >MySQL索引基础</font></center>

# 一.索引介绍

## 1.1 索引概念

索引是数据存储引擎用来快速查找数据表的记录(数据表的每一行)的数据结构，在MySQL中也叫'Keys'。索引在MySQL的性能表现中起着关键作用，特别是随着数据量的增长，索引越发显得重要。

## 1.2 索引基础

理解索引的一个比较容易的方式就是想一下书本的目录，通过目录可以快速找到某个书中所讨论的主题，特别是非常
厚的书，目录可以极大的加快找到某个话题的速度。

MySQL中的索引包含来自数据表的某个或多个字段的值，如果在不同的字段上使用看了索引，那么字段的顺序是非常
重要的,因为MySQL只能在索引的最左前缀快速的搜索。

### 1.2.1 索引类型

索引种类很多，不同的索引针对不同的目的而设计。索引在数据存储引擎层实现，不是所有数据引擎都支持所有索引，不同的数据引擎对于自己支持的索引的实现也不一样。

- B-Tree 索引

B树是一种常见的数据结构，其设计目的是为了加快数据库中数据引擎对于数据的存取速度，使用其来定位数据在
磁盘的位置。在MySQL中使用的Innodb数据引擎使用页(page)的概念管理磁盘，默认Innodb的页大小为16K，也可以
通过系统参数innodb_page_size来设置页大小(4K,8K,16K)。在连接到mysql的session中使用如下命令查看当前页大小:
> mysql> SHOW VARIABLES LIKE 'innodb_page_size';

```sql
MariaDB [mysql]> SHOW VARIABLES LIKE 'innodb_page%';;
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| innodb_page_size | 16384 |
+------------------+-------+
1 row in set (0.00 sec)
```

而一般操作系统文件系统所使用的最小磁盘管理单位为512字节或者2K或者4K，不会到16K。此时如果InnoDB每次申请
磁盘空间，都会顺序的使用多个文件系统的块来凑成16K，可以想象的是如果没有索引，查找某条数据时可能要读取
多个16K的磁盘页面，此时在操作系统层面实际上读取了多个更小的磁盘块，将会产生大量的磁盘I/O，很影响性能；
引入索引后，某个16K的页内的数据项可以记录其它数据项的位置，可以方便的找到其它数据项，大幅减少磁盘I/O，
提高查询效率。
B-Tree在数据库中的结构如图1中的上部分。B-Tree 的每个节点都由一个二元组定义(Key, Pointer-to-data),Key为记录的键值，
对应表中的主键值，Pointer-to-data为指向数据的指针。图1下部分为B+Tree,B+Tree与B-Tree的主要区别在于：B-Tree
中每个节点(叶节点和非叶子节点)都包含Key和指向数据的指针，一旦定位某个节点后就可以根据该节点存储的指针找到
数据存储的地址；而B+Tree则是将所有数据指针存放在叶子节点中，其它节点只存放索引。
![](png/B+TREE.png)
<center><font face="黑体" color="grey" size="2" >图1 B-Tree在数据库中和数据表关联后的结构</font></center>

- B+Tree 索引
![](png/B+tree-index.png)
<center><font face="黑体" color="grey" size="2" >图2 B+Tree在数据库中和数据表关联后的结构</font></center>

由图2可以看出由于非叶子节点没有存储指向数据的指针，所以可以存储更多的索引加载进内存。而不用存指针来占用宝贵的
内存资源，并且每个叶子节点存储有指向下一个叶子节点的指针，加速访问顺序存放的数据。

- Hash 索引

Hash索引是基于哈希表实现的一种索引，只有精确匹配索引中的所有列的查询才有效，索引自身只存储索引列对应的哈希值和
数据指针，索引结构紧凑，查询性能好。
Memory存储引擎支持显式hash索引，InnoDB和MyISAM存储引擎不支持

- Hash索引适用场景

```sql
只支持等值比较查询，包括=, <=>, IN()
```

- 不适合使用hash索引的场景

```sql
不适用于顺序查询：索引存储顺序的不是值的顺序
不支持模糊匹配
不支持范围查询
不支持部分索引列匹配查找：如A，B列索引，只查询A列索引无效
```

- 空间数据索引R-Tree(Geospatial indexing)
MyISAM支持地理空间索引，可以使用任意维度组合查询，使用特有的函数访问，常用于做地理数据存储，使用不多
InnoDB从MySQL5.7之后也开始支持空间数据索引

- 全文索引(FULLTEXT)
在文本中查找关键词，而不是直接比较索引中的值，类似搜索引擎
InnoDB从MySQL 5.6之后也开始支持全文索引

### 1.2.2 索引的好处

索引可以降低服务需要扫描的数据量，减少磁盘IO次数
索引可以帮助服务器避免排序和使用临时表
索引可以帮助将随机I/O转为顺序I/O

- 在MySQL中适用于B+Tree索引的查询类型

```sql
全值匹配：精确匹配所有带索引的字段  如：firstName:li lastNname:suo age:18
匹配最左前缀：即只使用索引的第一列  如：firstName:li
匹配列前缀：只匹配一列值开头部分    如：lastName字段以w开头的
匹配范围值：如：lastName字段li和姓wang之间
精确匹配某一列并在某范围匹配另一列：如：firstName:li lastNname字段以s开头的
只访问索引的查询
```

> [参考书目High.Performance.MySQL.3rd.Edition](https://github.com/JaccyLi/M39-Slides-Edited-notes/blob/master/Modern%20Operating%20Systems%204th%20Edition--Andrew%20Tanenbaum.pdf)

# 二.MySQL索引优化

## 2.1 独立地使用列

尽量避免其参与运算，独立的列指索引列不能是表达式的一部分，也不能是函数的参数，在where条件中，始终将索引列
单独放在比较符号的一侧

## 2.2 左前缀索引

构建指定索引字段的左侧的字符数，要通过索引选择性来评估
索引选择性：不重复的索引值和数据表的记录总数的比值

## 2.3 多列索引

AND操作时更适合使用多列索引，而非为每个列创建单独的索引

## 2.4 选择合适的索引列顺序

无排序和分组时，将选择性最高放左侧

## 2.5 索引优化建议

- 只要列中含有NULL值，就最好不要在此列设置索引，复合索引如果有NULL值，此列在使用时也不会使用索引
- 尽量使用短索引，如果可以，应该制定一个前缀长度
- 对于经常在where子句使用的列，最好设置索引
- 对于有多个列where或者order by子句，应该建立复合索引
- 对于like语句，以%或者‘-’开头的不会使用索引，以%结尾会使用索引
- 尽量不要在列上进行运算(函数操作和表达式操作)
- 尽量不要使用not in和<>操作
- 查询时，能不要*就不用*，尽量写全字段名
- 大部分情况连接效率远大于子查询
- 多表连接时，尽量小表驱动大表，即小表 join 大表
- 在有大量记录的表分页时使用limit
- 对于经常使用的查询，可以开启缓存
- 多使用explain和profile分析查询语句
- 查看慢查询日志，找出执行时间长的sql语句优化

# 三.MySQL索引管理

## 3.1 索引的简单管理

- 创建索引

```sql
CREATE [UNIQUE] INDEX index_name ON tbl_name (index_col_name[(length)],...);
ALTER TABLE tbl_name ADD INDEX index_name(index_col_name);
help CREATE INDEX;
```

> [官方文档-CREATE INDEX clause](https://dev.mysql.com/doc/refman/5.7/en/create-index.html)

- 查看索引
`SHOW INDEXES FROM [db_name.]tbl_name;`

- 优化表空间
`OPTIMIZE TABLE tb_name;`
- 由于比较大的单个表在其中的部分记录被删除后，其所占的存储空间不会减少；使用该命令可以让其占磁盘空间大小和表中
真实的数据大小一致。

- 查看索引的使用

```sql
SET GLOBAL userstat=1;
SHOW INDEX_STATISTICS;
```

## 3.2 使用EXPLAIN工具优化查询和索引

- 可以通过EXPLAIN来分析索引的有效性,获取查询的执行计划信息,以及用来查看查询优化器是如何执行查询的。
- EXPLAIN 用法
`EXPLAIN SELECT clause`

```sql
MariaDB [hellodb]> EXPLAIN SELECT stuid FROM students;
+------+-------------+----------+-------+---------------+---------+---------+------+------+-------------+
| id   | select_type | table    | type  | possible_keys | key     | key_len | ref  | rows | Extra       |
+------+-------------+----------+-------+---------------+---------+---------+------+------+-------------+
|    1 | SIMPLE      | students | index | NULL          | PRIMARY | 4       | NULL |   25 | Using index |
+------+-------------+----------+-------+---------------+---------+---------+------+------+-------------+
1 row in set (0.01 sec)
```

- EXPLAIN输出信息说明

|列名|解释|
|---|---|
|id | 执行编号，标识select所属的行。如果在语句中没子查询或关联查询，只有唯一的select，每行都将显示1。否则，内层的select语句一般会顺序编号，对应于其在原始语句中的位置|
|select_type|SIMPLE:简单查询 PRIMARY:复杂查询(最外面的SELECT)、DERIVED（用于FROM中的子查询）、UNION（UNION语句的第一个之后的SELECT语句）、UNION RESUlT（匿名临时表）、SUBQUERY（简单子查询）|
|table |访问引用哪个表（引用某个查询，如“derived3”）|
|type |关联类型或访问类型，即MySQL决定的如何去查询表中的行的方式|
|possible_keys |查询可能会用到的索引|
|key |显示mysql决定采用哪个索引来优化查询
|key_len |显示mysql在索引里使用的字节数
|ref |根据索引返回表中匹配某单个值的所有行
|rows |为了找到所需的行而需要读取的行数，估算值，不精确。通过把所有rows列值相乘，可粗略估算整个查询会检查的行数
|Extra |额外信息
|Using index：MySQL将会使用覆盖索引，以避免访问表
|Using where：MySQL服务器将在存储引擎检索后，再进行一次过滤
|Using temporary：MySQL对结果排序时会使用临时表
|Using filesort：对结果使用一个外部索引排序|

- type列显示的是访问类型，其值有多个。是较为重要的一个指标，结果值从好到坏依次是:
`system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL`
- 一般来说，得保证查询至少达到range级别，最好能达到ref

- type列每个值的意义

|值|意义|
|---|---|
|All |最坏的情况,全表扫描
|index |和全表扫描一样。只是扫描表的时候按照索引次序进行而不是行。主要优点就是避免了排序, 但是开销仍然非常大。如在Extra列看到Using index，说明正在使用覆盖索引，只扫描索引的数据，它比按索引次序全表扫描的开销要小很多
|range |范围扫描，一个有限制的索引扫描。key 列显示使用了哪个索引。当使用=、 <>、>、>=、<、<=、IS NULL、<=>、BETWEEN 或者 IN 操作符,用常量比较关键字列时,可以使用 range
|ref |一种索引访问，它返回所有匹配某个单个值的行。此类索引访问只有当使用非唯一性索引或唯一性索引非唯一性前缀时才会发生。这个类型跟eq_ref不同的是，它用在关联操作只使用了索引的最左前缀，或者索引不是UNIQUE和PRIMARY KEY。ref可以用于使用=或<=>操作符的带索引的列。
|eq_ref |最多只返回一条符合条件的记录。使用唯一性索引或主键查找时会发生 （高效）
|const |当确定最多只会有一行匹配的时候，MySQL优化器会在查询前读取它而且只读取一次，因此非常快。当主键放入where子句时，mysql把这个查询转为一个常量（高效）
|system |这是const连接类型的一种特例，表仅有一行满足条件。
|Null |意味着mysql能在优化阶段分解查询语句，在执行阶段甚至用不到访问表或索引（高效）