
FROM mariadb/server:10.4

#RUN addgroup --system --gid 999 mysql && \
#    adduser --system --uid 999 --gid 999 --disabled-login --disabled-password --no-create-home --gecos MySQL mysql && \
RUN chown mysql:mysql /etc/mysql/conf.d && \
    chown mysql:mysql /var/lib/mysql && \
    chown mysql:mysql /docker-entrypoint-initdb.d && \
    chmod 755 /etc/mysql/conf.d && \
    chmod 755 /var/lib/mysql && \
    chmod 755 /docker-entrypoint-initdb.d && \
    chmod 777 /run

USER mysql

#ENTRYPOINT sleep 3600
#ENTRYPOINT /docker-entrypoint.sh --user=mysql --tmpdir=/tmp

