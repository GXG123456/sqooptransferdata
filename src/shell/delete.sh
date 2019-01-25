#!/bin/bash
logfile=log.txt
date=`date +%Y_%m_%d_%H_%M_%S`
#sh ./import_com_organization.sh
#source ./import_person_info.sh

v_sql="insert overwrite table test.overdue_detail select a.* from test.overdue_detail a where not exists(select null from test.overdue_detail_log b where b.table_id = a.id)"

del_sql="TRUNCATE table test.overdue_detail_log"

hadoop fs -test -f /user/hive/warehouse/test.db/overdue_detail/*
if [ $? -eq 0 ] ;then 
    echo '文件目录已经存在，执行增量导入' 

    ./increment.sh
  echo "增量执行完毕"
   ./delincrement.sh

   hive -e "$v_sql;"
   
else 
    echo '文件目录不存在，执行全量导入操作' 
    ./import_overdue_detail.sh  
fi

if [ $? -ne 0 ]; then
    echo "failed"
    cd /home/log
    echo "执行失败"$date >> $logfile
else
    echo "succeed"
    cd /home/log
    echo "执行成功"$date >> $logfile
fi
echo "任务执行结束"
exit 0  
