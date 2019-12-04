#!/bin/sh

exec /usr/local/bin/memcached \
 -l $(hostname -i) -p 11211 -U 0 \
 -t $MEMCACHED_THREAD_COUNT \
 -R $MEMCACHED_CONNECTION_REQUESTS \
 $MEMCACHED_LOG_LEVEL

