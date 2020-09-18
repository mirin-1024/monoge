FROM mysql:8.0

COPY my.cnf /etc/mysql/conf.d
COPY grant_user.sql /docker-entrypoint-initdb.d
