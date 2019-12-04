#!/bin/sh

exec /usr/sbin/rrdcached \
  -g \
  -U rrdcached -G rrdcached \
  -l $(hostname -i):42217 \
  -p /var/run/rrdcached.pid \
  -j /journal -F \
  -b /data -B -R \
  -a $RRDCACHED_CHUNK_SIZE \
  -t $RRDCACHED_THREAD_COUNT \
  -f $RRDCACHED_FLUSH_INTERVAL \
  -w $RRDCACHED_WRITE_INTERVAL -z $RRDCACHED_WRITE_DELAY \
  -V $RRDCACHED_LOG_LEVEL

