
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash

COPY entrypoint.sh .

RUN mkdir -p /etc/mysql/conf.d && \
    mkdir -p /docker-entrypoint-initdb.d && \
    mkdir -p /var/lib/mysql

COPY librenms.cnf alter.sql /

ENTRYPOINT ["/entrypoint.sh"]

