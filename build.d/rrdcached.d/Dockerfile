
FROM alpine:3.10

RUN apk update && \
    apk upgrade && \
    apk add --no-cache rrdtool-cached && \
    addgroup -S -g 1010 rrdcached && \
    adduser -S -u 1010 -G rrdcached -g rrdcached rrdcached && \
    mkdir -p /rrd/data /rrd/journal && \
    chown -R rrdcached:rrdcached /rrd && \
    chmod -R 755 /rrd && \
    mkdir -p /sock && \
    chmod 777 /sock && \
    chmod 777 /run

COPY ./entrypoint.sh /

RUN chown rrdcached:rrdcached /entrypoint.sh && \
    chmod 755 /entrypoint.sh 

VOLUME /rrd/data /rrd/journal /sock

USER rrdcached

ENV RRDCACHED_CHUNK_SIZE=1 \
    RRDCACHED_THREAD_COUNT=4 \
    RRDCACHED_FLUSH_INTERVAL=600 \
    RRDCACHED_WRITE_INTERVAL=300 \
    RRDCACHED_WRITE_DELAY=15 \
    RRDCACHED_LOG_LEVEL=LOG_EMERG

ENTRYPOINT ["/entrypoint.sh"]

