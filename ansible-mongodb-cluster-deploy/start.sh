mongo {{ primary }}:27017  << EOF
use admin;
cfg={ _id:"demo",members:[{_id:0,host: "{{ primary }}:27017",priority:2},{_id:1,host: "{{ secondary }}:27017",priority:1},{_id:2,host: "{{ arbiter }}:27017",arbiterOnly:true}] };
rs.initiate(cfg);
EOF

sleep 30

mongo {{ primary }}:27017  << EOF
rs.status();
EOF
