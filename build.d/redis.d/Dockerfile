
FROM redis:5.0-alpine

RUN chmod 777 /data && \
    chmod 777 /run

COPY redis.conf /usr/local/etc/redis/redis.conf
COPY ./entrypoint.sh /

RUN chown redis:redis /usr/local/etc/redis/redis.conf && \
    chmod 644 /usr/local/etc/redis/redis.conf && \
    chown redis:redis /entrypoint.sh && \
    chmod 755 /entrypoint.sh 

VOLUME /data

USER redis

EXPOSE 36379

ENV REDIS_LOG_LEVEL=notice

ENTRYPOINT ["/entrypoint.sh"]

