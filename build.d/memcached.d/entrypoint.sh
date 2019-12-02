#!/bin/sh

exec /usr/local/bin/memcached \
 -s /sock/memcached.sock -a 0660 \
 -t $MEMCACHED_THREAD_COUNT \
 -R $MEMCACHED_CONNECTION_REQUESTS \
 $MEMCACHED_LOG_LEVEL

