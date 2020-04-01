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

