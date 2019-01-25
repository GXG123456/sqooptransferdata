#!/bin/bash
datenow=$(date -d 'last day' -I)
databases=("FRONTBANK")

sqoop import \
--connect jdbc:oracle:thin:@172.16.230.11:1521:zdxdb \
--username frontbank \
--password sdff23s \
--query 'SELECT b.TABLE_ID, b.UPDATE_DATE FROM  FRONTBANK.OVERDUE_DETAIL_LOG b WHERE b.OPERTATION_TYPE=0 and $CONDITIONS' \
--split-by TABLE_ID \
--fields-terminated-by ',' \
--incremental lastmodified \
--check-column UPDATE_DATE \
--last-value ${datenow} \
--merge-key TABLE_ID \
--hive-drop-import-delims \
-m 1 \
--null-non-string '\\N' \
--null-string '\\N' \
--target-dir /user/hive/warehouse/test.db/overdue_detail_log/