
FROM memcached:1.5-alpine

USER root

RUN addgroup -S -g 1010 memcached && \
    adduser -S -u 1010 -G memcached -g memcached memcached && \
    chmod 777 /run

COPY ./entrypoint.sh /

RUN chown memcached:memcached /entrypoint.sh && \
    chmod 755 /entrypoint.sh 

USER memcached

ENV MEMCACHED_THREAD_COUNT=4 \
    MEMCACHED_CONNECTION_REQUESTS=20 \
    MEMCACHED_LOG_LEVEL=

ENTRYPOINT ["/entrypoint.sh"]

