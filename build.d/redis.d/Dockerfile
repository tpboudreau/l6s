
FROM redis:5.0-alpine

RUN addgroup -S -g 1010 redisd && \
    adduser -S -u 1010 -G redisd -g redisd redisd && \
    chmod 777 /data && \
    chmod 777 /run

COPY redis.conf /usr/local/etc/redis/redis.conf
COPY ./entrypoint.sh /

RUN chown redis:redis /usr/local/etc/redis/redis.conf && \
    chmod 644 /usr/local/etc/redis/redis.conf && \
    chown redis:redis /entrypoint.sh && \
    chmod 755 /entrypoint.sh 

VOLUME /data

USER redisd

ENV REDIS_LOG_LEVEL=notice

ENTRYPOINT ["/entrypoint.sh"]

