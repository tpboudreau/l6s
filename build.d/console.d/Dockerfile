
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bind-tools curl libmemcached mariadb-client redis rrdtool wget

COPY commands /

RUN chmod 644 /commands

ENV MYSQL_HOST=n.n.n.n \
    MYSQL_PORT=p \
    RRDCACHED_ADDRESS=n.n.n.n:p \
    MEMCACHED_SERVERS=n.n.n.n:p \
    REDIS_HOST=n.n.n.n \
    REDIS_PORT=p \
    REDISCLI_AUTH=x

ENTRYPOINT sleep 3600

