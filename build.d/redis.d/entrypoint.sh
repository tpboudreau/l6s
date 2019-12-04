#!/bin/sh

exec redis-server /usr/local/etc/redis/redis.conf \
  --bind $(hostname -i) \
  --port 6379 \
  --requirepass ${REDIS_REQUIRED_PASSWORD} \
  --loglevel ${REDIS_LOG_LEVEL}

