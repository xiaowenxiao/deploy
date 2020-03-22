# tips

**1. 编辑变量**

```
vim /etc/ansible/hosts

[etcd]
172.20.10.5 etcd_name=etcd-1
172.20.10.6 etcd_name=etcd-2
172.20.10.7 etcd_name=etcd-3

[etcd:vars]
etcd_work_dir=/opt/etcd
```



**2. 生成etcd证书**

```
ansible-playbook tls.yaml -k
```



**3. 创建etcd集群**

```
ansible-playbook etcd.yaml -k
```



### 