#!/bin/bash
set -x
set -eo pipefail

# 定义变量
install_path=`pwd`
zookeeper_dataDir=${install_path}/zookeeper/data
server_1=172.20.10.5
server_2=172.20.10.6
server_3=172.20.10.7

# 初始化
systemctl stop firewalld&&systemctl disable firewalld.service
cat << EOF >   /etc/sysconfig/selinux
SELINUX=disabled
EOF

# 安装JDK
yum install -y java-1.8.0-openjdk
yum install -y java-1.8.0-openjdk-devel

cat >> /etc/profile <<EOF
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.el7_7.x86_64
export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH=$PATH:\$JAVA_HOME/jre/bin
EOF

source /etc/profile

# 下载解压zookeeper、kafka
tar zxvf pkg/apache-zookeeper-3.5.5-bin.tar.gz -C ./
mv apache-zookeeper-3.5.5-bin zookeeper
tar zxvf pkg/kafka_2.11-2.3.1.tgz -C ./
mv kafka_2.11-2.3.1 kafka

mv zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg

cat > zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=${zookeeper_dataDir}
clientPort=9081
admin.serverPort=9091
server.1=${server_1}:2888:3888
server.2=${server_2}:2888:3888
server.3=${server_3}:2888:3888
EOF
