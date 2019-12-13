
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache tree && \
    mkdir -p /mysql /rrdcached /redis && \
    chmod 755 /mysql /rrdcached /redis

ENTRYPOINT sleep 3600

