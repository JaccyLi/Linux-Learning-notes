# 一. Kafka 介绍

![](png/kafka.png)

Kafka 被称为下一代分布式消息系统，是非营利性组织 ASF(Apache Software
Foundation，简称为 ASF)基金会中的一个开源项目，比如 HTTP Server、Hadoop、
ActiveMQ、Tomcat 等开源软件都属于 Apache 基金会的开源软件，类似的消息系
统还有 RbbitMQ、ActiveMQ、ZeroMQ。

实际上 Kafka 最初由 Linkedin 公司开发，是一个分布式、支持分区的（partition）、
多副本的（replica），基于 zookeeper 协调的分布式消息系统，它的最大的特性就
是可以实时的处理大量数据以满足各种需求场景：比如基于 hadoop 的批处理系统、
低延迟的实时系统、storm/Spark 流式处理引擎，web/nginx 日志、访问日志，消息
服务等，Kafka 用 scala 语言编写，Linkedin 于 2010 年贡献给了 Apache 基金
会并成为 ASF 顶级开源项目。

# 二. Kafka 架构和优势

## 2.1 Kafka 涉及的概念

## 2.2 Kafka 的优势

# 三. Kafka 部署

环境：

| 主机名           | IP              | 运行服务         |
| :--------------- | :-------------- | :--------------- |
| zoo-server-node1 | 192.168.100.160 | ZooKeeper、Kafka |
| zoo-server-node2 | 192.168.100.162 | ZooKeeper、Kafka |
| zoo-server-node3 | 192.168.100.164 | ZooKeeper、Kafka |

## 3.1 Kafka 版本选择

## 3.2 各节点部署 Kafka

## 3.3 各节点启动 Kafka

## 3.4 查看 zookeeper 中的元数据

# 四. 测试 Kafka 读写数据
