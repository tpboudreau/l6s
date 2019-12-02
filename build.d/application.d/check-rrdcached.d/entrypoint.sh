#!/bin/sh

. /services.sh

export RRDCACHED_ADDRESS=${LIBRENMS_RRDCACHED_HOST}:${LIBRENMS_RRDCACHED_PORT}

exec /usr/bin/rrdtool list /

