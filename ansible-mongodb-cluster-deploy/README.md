# Tips

## mongodb集群架构

主从架构（Master-Slave）、副本集架构（Replica Set）、数据分片架构（Sharding）

这里安装集群的方式为副本集架构（Replica Set）

> Primary：主节点，唯一
> Secondary：从节点，同步主节点的数据，可以多个实例，可只读
> Hidden：备份节点，不处理任何客户端驱动请求
> Secondary-Only：只能为从节点，防止一些性能不高的节点成为主节点
> Non-Voting：没有选举权的 secondary 节点，备份使用，虽然不清楚和隐藏节点的差别是什么
> Arbiter：仲裁节点，不存数据，只参与仲裁，可选



## 安装

修改hosts文件，修改对应的host、安装目录等

```
[primary]
172.20.10.5

[secondary]
172.20.10.6

[arbiter]
172.20.10.7

[all:vars]
primary='172.20.10.5'
secondary='172.20.10.6'
arbiter='172.20.10.7'
ins_dir='/tmp'
confPath='/etc/mongod.conf'
mongoDataPath='/data/mongodb/data'
mongopath='/data/mongodb'
```



执行安装

```
ansible-playbook -i hosts mongodb.yaml -k
```

