cd {{ ins_dir }}/pkg  
yum install -y * 
mongod -f {{ confPath }} 

