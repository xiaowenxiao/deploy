cd {{ ins_dir }}/pkg  
yum install -y * 
mongod -f {{ confPath }} 
#mongo {{ primary }}:27017  << EOF
#use admin;
#cfg={ _id:"demo",members:[{_id:0,host: "{{ primary }}:27017",priority:2},{_id:1,host: "{{ secondary }}:27017",priority:1},{_id:2,host: "{{ arbiter }}:27017",arbiterOnly:true}] };
#rs.initiate(cfg);
#rs.status();
#EOF
