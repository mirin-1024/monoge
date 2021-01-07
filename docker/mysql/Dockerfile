FROM mysql:8.0

RUN mkdir /var/log/mysql
RUN chown mysql:mysql /var/log/mysql

COPY ./docker/mysql/my.cnf /etc/mysql/conf.d
COPY ./docker/mysql/grant_user.sql /docker-entrypoint-initdb.d
