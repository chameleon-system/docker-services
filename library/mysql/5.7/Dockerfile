FROM mysql:5.7

# Adding chameleon specific mysql
COPY config/esono.cnf /etc/mysql/conf.d/esono.cnf

# Adding generic mysql backup script
COPY scripts/mysql_backup.sh /usr/local/bin/mysql_backup.sh

RUN chmod 644 /etc/mysql/conf.d/esono.cnf
