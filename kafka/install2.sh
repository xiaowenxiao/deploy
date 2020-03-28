#!/bin/bash
# 安装第二台
set -eo pipefail
install_path=`pwd`
zookeeper_dataDir=${install_path}/zookeeper/data
source ${install_path}/init.sh

mkdir -p ${zookeeper_dataDir} && cd ${zookeeper_dataDir}
touch myid
cat > myid <<EOF
2
EOF

cat > ${install_path}/kafka/config/server.properties <<EOF
broker.id=2
listeners=PLAINTEXT://${server_2}:9082
host.name=${server_2}
zookeeper.connect=${server_1}:9081,${server_2}:9081,${server_3}:9081
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/tmp/kafka-logs
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connection.timeout.ms=6000
group.initial.rebalance.delay.ms=0
EOF

# 启动zookeeper
cd ${install_path}/zookeeper/bin&&./zkServer.sh start
echo "#### zookeeper启动成功 ####"

# 启动kafka
cd ${install_path}/kafka/bin&&./kafka-server-start.sh -daemon ../config/server.properties
echo "#### kafka启动成功 ####"