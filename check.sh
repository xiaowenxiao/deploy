#! /bin/bash

# This is 初始化及服务检查 shell script.
# 使用到sshpass,离线需将sshpass rpm包放置跟脚本同级目录下.
# 当前脚本需在swarm leader节点执行,仅支持所有服务器密码一致的情况下使用.
# 该脚本仅在操作系统CentOS7.6-7.9测试成功.
# Writen by Xiaowenxiao 2021-03-10.

IP=$(ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g'|head -n 1)
usage(){
cat <<-EOF
	Usage: $0 -p [PASSWORD]
	Tips: 当前脚本需在swarm leader节点执行,仅支持所有服务器密码一致的情况下使用.
EOF
    exit 1
}

if [ -z $1 ]; then
    usage
fi

while getopts 'p:h:?' OPT; do
    case $OPT in
        p) PASSWORD="$OPTARG";;
        h) usage;;
        ?) usage;;
    esac
done

pre(){
	systemctl status docker >/dev/null 2>&1 
	[[ $? != 0 ]] && echo -e "[${IP}]:请检查docker服务状态,确保服务状态正常再执行: bash $0\n" && exit -1
	if [[ $(docker node ls | grep Leader | awk '{print $3}') == $(hostname) ]];then
	   rpm -qa | grep sshpass >/dev/null 2>&1 
	   if [[ $? != 0 ]];then
              yum install -y sshpass >/dev/null 2>&1 
		if [[ $? != 0 ]];then
	           rpm -ivh $(cd $(dirname $0); pwd)/sshpass*.rpm >/dev/null 2>&1
		fi
	   fi
           clear
	fi
}

init_check(){
	echo -e "[${IP}]Docker_Node_Labels: $(docker node inspect --format '{{.Spec.Labels}}' `hostname`)"
	printf "%-10s %-18s %-25s %s\n" HOSTNAME IP CHECKITEM STATUS
	printf "%-10s %-18s %-25s %-99s\n" $(hostname) ${IP} selinux $(getenforce)/$(cat /etc/selinux/config | grep SELINUX= | grep -v \# | tr -d SELINUX=)
	printf "%-10s %-18s %-25s %-99s\n" $(hostname) ${IP} ipv4.ip_forward $(cat /proc/sys/net/ipv4/ip_forward)
}

service_check(){
	SERVICE_LIST=(
		sshd
           	ntpd
	        firewalld
	        docker
		ceph-crash
		ceph-mds@$(hostname)
		ceph-mgr@$(hostname)                                             
		ceph-mon@$(hostname)                                             
		ceph-radosgw@rgw.$(hostname)
	)

	for service in ${SERVICE_LIST[@]}
	do
	  systemctl status ${service} >/dev/null 2>&1
	  if [[ $? == 4 ]];then
		SERVICE_STATUS="NotInstalled"
		printf "%-10s %-18s %-25s %-99s\n" $(hostname) ${IP} ${service} ${SERVICE_STATUS}
	  else
		INIT=$(systemctl list-unit-files | grep ${service}.service | awk '{print $2}')
	  	SERVICE_STATUS=$(systemctl status ${service} | grep Active| head -n 1 | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
	  	printf "%-10s %-18s %-25s %-99s\n" $(hostname) ${IP} ${service} "${SERVICE_STATUS}/${INIT}"
	  fi
	done
	echo "==============================================================================="
}

copy_script(){
        NODE_LIST=$(docker node ls | grep -v Leader | awk '{print$2}' | tail -n +2)
	for node in ${NODE_LIST}
	do
		sshpass -p ${PASSWORD} scp -o StrictHostKeyChecking=no -q $(cd `dirname $0`; pwd)/$0 root@${node}:/tmp/
		sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no root@${node} bash /tmp/check.sh -p ${PASSWORD}	
	done
}

pre
init_check
service_check
[[ $(docker node ls | grep Leader | awk '{print $3}') == $(hostname) ]] && copy_script	

