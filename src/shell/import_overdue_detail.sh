#!/bin/bash
url="jdbc:oracle:thin:@172.16.230.11:1521:zdxdb"
database="XD_CORE"
tables=("OVERDUE_DETAIL")
tables_num=${#tables[@]}
username="frontbank"
password="sdff23s"
for((i=0;i<tables_num;i++));
do
sqoop import \
--connect ${url} \
--username ${username} \
--password ${password} \
--query 'SELECT a.*,b.UPDATE_DATE FROM  FRONTBANK.OVERDUE_DETAIL a , FRONTBANK.TIME_TABLE b WHERE b.id=0 and $CONDITIONS' \
--target-dir /user/hzp/test1 \
--hive-drop-import-delims \
--fields-terminated-by '/t' \
--m 2 \
--split-by a.ID \
--hive-import \
--hive-overwrite \
--hive-database test \
--hive-table ${tables[i]} \
--verbose 
done