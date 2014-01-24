#!/bin/sh
echo "update orders set visibility_status='VISIBLE' where visibility_status='QUARANTINE' order by created_at desc LIMIT 1;" > /tmp/uq.sql
mysql -uroot --database=coreapp < /tmp/uq.sql