> 1.nginx 和 apache 的区别?

> 2.LVS 三种模式的工作过程?
> 3.mysql 数据库备份的方法? 
>
> 4.列举知道的负载均衡 
>
> 5.源码编译安装 apache,要求为:安装目录为/usr/local/apache,需有压缩模块，
> rewrite,worker 模式;并说明在 apache 的 worker MPM 中，为什么 ServerLimit 要
> 放到配置段最前面? 
>
> 6. 
> 7. 
> 8. 8.hellodb_innodb.sql 内容如下，使用其生成的表来完成以下查询。

```sql
-- MySQL dump 10.13  Distrib 5.5.33, for Linux (x86_64)
--
-- Host: localhost    Database: hellodb
-- ------------------------------------------------------
-- Server version       5.5.33-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `hellodb`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hellodb` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `hellodb`;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classes` (
  `ClassID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `Class` varchar(100) DEFAULT NULL,
  `NumOfStu` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ClassID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coc`
--

DROP TABLE IF EXISTS `coc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ClassID` tinyint(3) unsigned NOT NULL,
  `CourseID` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coc`
--

LOCK TABLES `coc` WRITE;
/*!40000 ALTER TABLE `coc` DISABLE KEYS */;
INSERT INTO `coc` VALUES (1,1,2),(2,1,5),(3,2,2),(4,2,6),(5,3,1),(6,3,7),(7,4,5),(8,4,2),(9,5,1),(10,5,9),(11,6,3),(12,6,4),(13,7,4),(14,7,3);
/*!40000 ALTER TABLE `coc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `CourseID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Course` varchar(100) NOT NULL,
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Hamo Gong'),(2,'Kuihua Baodian'),(3,'Jinshe Jianfa'),(4,'Taiji Quan'),(5,'Daiyu Zanghua'),(6,'Weituo Zhang'),(7,'Dagou Bangfa');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scores` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `StuID` int(10) unsigned NOT NULL,
  `CourseID` smallint(5) unsigned NOT NULL,
  `Score` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores`
--

LOCK TABLES `scores` WRITE;
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `StuID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Age` tinyint(3) unsigned NOT NULL,
  `Gender` enum('F','M') NOT NULL,
  `ClassID` tinyint(3) unsigned DEFAULT NULL,
  `TeacherID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`StuID`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teachers` (
  `TID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Age` tinyint(3) unsigned NOT NULL,
  `Gender` enum('F','M') DEFAULT NULL,
  PRIMARY KEY (`TID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES (1,'Song Jiang',45,'M'),(2,'Zhang Sanfeng',94,'M'),(3,'Miejue Shitai',77,'F'),(4,'Lin Chaoying',93,'F');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toc`
--

DROP TABLE IF EXISTS `toc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `toc` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `CourseID` smallint(5) unsigned DEFAULT NULL,
  `TID` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toc`
--

LOCK TABLES `toc` WRITE;
/*!40000 ALTER TABLE `toc` DISABLE KEYS */;
/*!40000 ALTER TABLE `toc` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-09-03  2:51:27
```

- 完成以下查询：

```sql

1. 在students表中，查询年龄大于25岁，且为男性的同学的名字和年龄

   SELECT name,age FROM students WHERE age > 25;

2. 以ClassID为分组依据，显示每组的平均年龄

   SELECT ClassID,AVG(age) FROM students GROUP BY ClassID;

3. 显示第2题中平均年龄大于30的分组及平均年龄

   SELECT ClassID,AVG(age) FROM students GROUP BY ClassID HAVING AVG(age) > 30;

4. 显示以L开头的名字的同学的信息

   SELECT * FROM students WHERE name LIKE 'L%';
   SELECT * FROM students WHERE name RLIKE '^L.*';
   SELECT * FROM students WHERE name REGEXP '^L.*';

5. 显示TeacherID非空的同学的相关信息

   SELECT * FROM students WHERE TeacherID IS NOT NULL;

6. 以年龄排序后，显示年龄最大的前10位同学的信息

   SELECT * FROM students ORDER BY age DESC LIMIT 10;

7. 查询年龄大于等于20岁，小于等于25岁的同学的信息

   SELECT * FROM students WHERE age BETWEEN 20 AND 25;

8. 以ClassID分组，显示每班的同学的人数

   SELECT ClassID,COUNT(classid) AS man_count FROM students GROUP BY ClassID;

9. 以Gender分组，显示其年龄之和

   SELECT gender,sum(age) AS total_age FROM students GROUP BY gender;

10. 以ClassID分组，显示其平均年龄大于25的班级

    SELECT ClassID FROM students GROUP BY ClassID HAVING AVG(age) > 25;

11. 以Gender分组，显示各组中年龄大于25的学员的年龄之和

    SELECT gender,SUM(age) FROM students WHERE age > 25 GROUP BY gender ;

12. 显示前5位同学的姓名、课程及成绩

    SELECT DISTINCT st.name,co.course,score FROM students st INNER JOIN scores sc ON st.stuid=sc.stuid INNER JOIN courses co ON sc.courseid=co.courseid WHERE st.stuid < 6;

13. 显示其成绩高于80的同学的名称及课程

    SELECT DISTINCT st.name,co.Course,score FROM students st INNER JOIN scores sc ON st.stuid=sc.stuid INNER JOIN courses co ON sc.courseid=co.courseid WHER sc..core > 80;

14. 取每位同学各门课的平均成绩，显示成绩前三名的同学的姓名和平均成绩

    SELECT DISTINCT st.name,co.Course,avg(score) FROM students st INNER JOIN scores sc ON st.stuid=sc.stuid INNER JOIN courses co ON sc.courseid=co.courseid GROUP BY st.name ORDER BY avg(score) DESC limit 3;

15. 显示每门课程课程名称及学习了这门课的同学的个数

    SELECT course,co.courseid,COUNT(stuid) FROM courses co LEFT JOIN scores sc ON co.courseid=sc.courseid GROUP BY courseid;

16. 显示其年龄大于平均年龄的同学的名字

    SELECT name FROM students WHERE age > (SELECT AVG(age) FROM students);

17. 显示其学习的课程为第1、2、4或第7门课的同学的名字
    select StuID ,Name from students where StuID in (select distinct StuID from scores where CourseID in (1, 2, 4, 7));
   -- SELECT StuID,name FROM  students WHERE ClassID IN (1,2,4,7);

18. 显示其成员数最少为3个的班级的同学中年龄大于同班同学平均年龄的同学
--select ClassID, count(*) as num  from students group by ClassID having ClassID is not null order by num limit 3;

-- select * from students as stu inner join (select ClassID, count(*) as num  from students group by ClassID having ClassID is not null order by num limit 3) as sclass on stu.ClassID = sclass.ClassID;

-- select stu.ClassID, avg(stu.Age) from students as stu inner join (select ClassID, count(*) as num  from students group by ClassID having ClassID is not null order by num limit 3) as sclass on stu.ClassID = sclass.ClassID group by stu.ClassID;

-- select * from students inner join (select stu.ClassID, avg(stu.Age) as avgAge from students as stu inner join (select ClassID, count(*) as num  from students group by ClassID having ClassID is not null order by num limit 3) as sclass on stu.ClassID = sclass.ClassID group by stu.ClassID) as avgtab on students.ClassID = avgtab.ClassID and students.age > avgtab.avgAge;



--    select classid,count(stuid) from students group by ClassID having count(stuid) >= 3;
--    select classid,count(stuid),avg(age) as class_avg_age from students group by ClassID having count(stuid) >= 3

19. 统计各班级中年龄大于全校同学平均年龄的同学
select * from students where Age > (select avg(Age) from students where classID is not null) and classID is not null;

```

> 9.存储引擎 InnoDB 和 MyISAM 的区别

| Feature           | InnoDB              | MyISAM              |
| ----------------- | ------------------- | ------------------- |
| MVCC              | 支持                | 不支持              |
| Transactions      | 支持                | 不支持              |
| Data caches       | 支持                | 不支持              |
| Foreign key       | 支持                | 不支持              |
| Clustered indexes | 支持                | 不支持              |
| 锁机制粒度        | 行级锁              | 表级锁              |
| 全文索引          | mysql5.5 版本后支持 | 支持                |
| 文件              | 两种:.ibd/.frm      | 三种:.frm/.MYD/.MYI |

- MyISAM 读取数据较快，占用资源少，崩溃恢复性差；Innodb 崩溃后恢复性更好。

> 10.使用 iptables 实现跨网段地址转换

```bash
# 请求报文目标地址转换
iptables -t nat -A PREROUTING -d 192.168.7.101 -p tcp --dport 3389 -j DNAT --to-destination 172.18.139.20:3389
# 响应报文返回转换
iptables -t nat -A POSTROUTING -s 192.168.0.0/21 -j SNAT --to-source  192.168.7.101
```
