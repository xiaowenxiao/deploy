# Tips

1、修改hosts文件，替换对应的主机，以及kafka安装的工作目录

```bash
[server_1]
172.20.10.5 

[server_2]
172.20.10.6 

[server_3]
172.20.10.7 

[all:vars]
server_1=172.20.10.5
server_2=172.20.10.6
server_3=172.20.10.7
work_dir=/data
```



2、执行安装

```bash
ansible-playbook -i hosts kafka.yaml -k
```



3、相关命令

```bash
# 启动/停止 zookeeper
cd ${install_path}/zookeeper/bin&&./zkServer.sh start
cd ${install_path}/zookeeper/bin&&./zkServer.sh stop

# 启动/停止 kafka
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

# 查看topic
./kafka-topics.sh --list --zookeeper localhost:9081

# 查看topic状态
./kafka-topics.sh --describe --zookeeper localhost:9081 --topic test
```

