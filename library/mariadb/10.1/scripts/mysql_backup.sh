#!/bin/bash
WEEKDAY=`/bin/date +%A`
for i in `/usr/bin/mysql -h mysql -uroot -p$MYSQL_ROOT_PASSWORD -Bs -e "show databases"`
do
ionice -c3 nice -n19 mysqldump -h mysql -uroot -p$MYSQL_ROOT_PASSWORD --opt --add-drop-table --quote-names --default-character-set=utf8 --single-transaction --quick --lock-tables=false "$i" | gzip > "/backup/$i.$WEEKDAY.sql.gz"
done
