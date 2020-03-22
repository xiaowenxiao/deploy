# tips

**1. 编辑变量**

```
vim /etc/ansible/hosts
# x.x.x.x 替换成对应的的ip地址
[etcd]
x.x.x.x etcd_name=etcd-1
x.x.x.x etcd_name=etcd-2
x.x.x.x etcd_name=etcd-3

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
