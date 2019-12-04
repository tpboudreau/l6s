
FROM alpine:3.10

RUN apk update && \
    apk upgrade && \
    apk add --no-cache rrdtool-cached && \
    addgroup -S -g 1010 rrdcached && \
    adduser -S -u 1010 -G rrdcached -g rrdcached rrdcached && \
    mkdir -p /data /journal && \
    chown -R rrdcached:rrdcached /data /journal && \
    chmod -R 755 /data /journal && \
    chmod 777 /run

COPY ./entrypoint.sh /

RUN chown rrdcached:rrdcached /entrypoint.sh && \
    chmod 755 /entrypoint.sh 

VOLUME /data /journal

USER rrdcached

ENV RRDCACHED_CHUNK_SIZE=1 \
    RRDCACHED_THREAD_COUNT=4 \
    RRDCACHED_FLUSH_INTERVAL=600 \
    RRDCACHED_WRITE_INTERVAL=300 \
    RRDCACHED_WRITE_DELAY=15 \
    RRDCACHED_LOG_LEVEL=LOG_EMERG

EXPOSE 42217

ENTRYPOINT ["/entrypoint.sh"]

