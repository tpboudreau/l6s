
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bind-tools curl libmemcached mariadb-client redis rrdtool wget

COPY commands environment.sh /

RUN chmod 644 /commands && \
    chmod 755 /environment.sh

ENTRYPOINT sleep 3600

