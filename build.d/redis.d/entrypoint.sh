#!/bin/sh

exec redis-server /usr/local/etc/redis/redis.conf --requirepass ${REDIS_REQUIRED_PASSWORD} --loglevel ${REDIS_LOG_LEVEL}

