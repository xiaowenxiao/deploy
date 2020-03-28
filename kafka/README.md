# Tips

> 此环境为3台服务器

```
.
├── init.sh
├── install1.sh
├── install2.sh
├── install3.sh
├── pkg
│   ├── apache-zookeeper-3.5.5-bin.tar.gz
│   └── kafka_2.11-2.3.1.tgz
└── README.md
```



## 1、修改init.sh内对应ip

```
...
server_1=172.20.10.5
server_2=172.20.10.6
server_3=172.20.10.7
...
```



## 2、部署

执行install*.sh进行安装（\*：为第\*台服务器，共3台服务器）



## 3、相关命令

```
# 启动zookeeper
cd ${install_path}/zookeeper/bin&&./zkServer.sh start
cd ${install_path}/zookeeper/bin&&./zkServer.sh stop

# 启动kafka
cd ${install_path}/kafka/bin&&./kafka-server-start.sh -daemon ../config/server.properties
cd ${install_path}/kafka/bin&&./kafka-server-stop.sh

# 创建 topic
./kafka-topics.sh --create --zookeeper 172.20.10.5:9081 --replication-factor 3 --partitions 3 --topic test
	#	--replication-factor 2   #复制3份
	#	--partitions 1 #创建3个分区
	#	--topic #主题为 superman

# 创建发布者
./kafka-console-producer.sh --broker-list 172.20.10.5:9082 --topic test
# 创建消费者
./kafka-console-consumer.sh --bootstrap-server 172.20.10.6:9082 --topic test --from-beginning
./kafka-console-consumer.sh --bootstrap-server 172.20.10.7:9082 --topic test --from-beginning
# 查看 topic
./kafka-topics.sh --list --zookeeper localhost:9081
# 查看 topic 状态
./kafka-topics.sh --describe --zookeeper localhost:9081 --topic test
```

