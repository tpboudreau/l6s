
FROM mariadb/server:10.4

RUN chown mysql:mysql /etc/mysql/conf.d && \
    chown mysql:mysql /var/lib/mysql && \
    chown mysql:mysql /docker-entrypoint-initdb.d && \
    chmod 755 /etc/mysql/conf.d && \
    chmod 755 /var/lib/mysql && \
    chmod 755 /docker-entrypoint-initdb.d && \
    chmod 777 /run

EXPOSE 33306

USER mysql

