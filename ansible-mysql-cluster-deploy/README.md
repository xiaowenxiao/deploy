# tips

## 1、编辑hosts文件

```
.
├── files
│   └── mysql.zip
├── hosts
├── init-0.sh
└── mysql.yaml
```

设置master、slave机器host及数据库密码

> 仅适用于一主多从，master只能配置一个，slave主机数根据需求添加

```shell
[master]
172.20.10.5

[slave]
172.20.10.6
172.20.10.7

[all:vars]
master_ip="172.20.10.5"
password="abcd@1234"
```



## 2、执行安装

```shell
ansible-playbook -i hosts mysql.yaml -k
```



## 3、检验集群状态

 登录从机上查看同步状态，下面两个参数都为Yes，说明主从复制集群状态正常

>  Slave_IO_Running: Yes
>  Slave_SQL_Running: Yes

```
[root@172_20_10_6 ~]# mysql -h127.0.0.1 -uroot -p${root_pass}

mysql> show slave status\G
```



```mysql
[root@172_20_10_6 ~]# mysql -h127.0.0.1 -uroot -p${root_pass}
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.7.27-log MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 172.20.10.5
                  Master_User: root
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 864
               Relay_Log_File: 172_20_10_7-relay-bin.000002
                Relay_Log_Pos: 1077
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 864
              Relay_Log_Space: 1290
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 9132
                  Master_UUID: f56b1848-6f39-11ea-8c7e-000c29e5b1fa
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: f56b1848-6f39-11ea-8c7e-000c29e5b1fa:1-3
            Executed_Gtid_Set: f56b1848-6f39-11ea-8c7e-000c29e5b1fa:1-3
                Auto_Position: 1
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
1 row in set (0.00 sec)
```

