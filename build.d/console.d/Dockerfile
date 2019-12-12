
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bind-tools curl libmemcached mariadb-client net-snmp-tools redis rrdtool wget

COPY commands /
COPY environment.sh /.profile

RUN chmod 644 /commands && \
    chmod 644 /.profile

ENTRYPOINT sleep 3600

