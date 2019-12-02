#!/bin/sh

. /services.sh

export MEMCACHED_SERVERS=${LIBRENMS_MEMCACHED_HOST}:${LIBRENMS_MEMCACHED_PORT}

exec memstat --verbose

