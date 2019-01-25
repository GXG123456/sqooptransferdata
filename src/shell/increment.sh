#!/bin/bash
datenow=$(date -d 'last day' -I)
databases=("FRONTBANK")

sqoop import \
--connect jdbc:oracle:thin:@172.16.230.11:1521:zdxdb \
--username frontbank \
--password sdff23s \
--query 'SELECT a.*, b.UPDATE_DATE FROM  FRONTBANK.OVERDUE_DETAIL a INNER JOIN FRONTBANK.OVERDUE_DETAIL_LOG b ON a.ID=b."TABLE_ID" where b.OPERTATION_TYPE=1 or b.OPERTATION_TYPE=2 and $CONDITIONS' \
--split-by a.ID \
--incremental lastmodified \
--check-column UPDATE_DATE \
--last-value ${datenow} \
--merge-key ID \
--hive-drop-import-delims \
--fields-terminated-by '/t' \
-m 1 \
--target-dir /user/hive/warehouse/test.db/overdue_detail/