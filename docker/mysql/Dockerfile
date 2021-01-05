FROM mysql:8.0

COPY ./docker/mysql/my.cnf /etc/mysql/conf.d
COPY ./docker/mysql/grant_user.sql /docker-entrypoint-initdb.d
