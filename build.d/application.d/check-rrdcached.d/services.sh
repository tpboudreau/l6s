#/bin/sh

export LIBRENMS_MYSQL_HOST=${MYSQL_SERVICE_HOST:-${LIBRENMS_MYSQL_HOST:-"127.0.0.1"}}
export LIBRENMS_MYSQL_PORT=${MYSQL_SERVICE_PORT:-${LIBRENMS_MYSQL_PORT:-"3306"}}

export LIBRENMS_RRDCACHED_HOST=${RRDCACHED_SERVICE_HOST:-${LIBRENMS_RRDCACHED_HOST:-"127.0.0.1"}}
export LIBRENMS_RRDCACHED_PORT=${RRDCACHED_SERVICE_PORT:-${LIBRENMS_RRDCACHED_PORT:-"42217"}}

export LIBRENMS_MEMCACHED_HOST=${MEMCACHED_SERVICE_HOST:-${LIBRENMS_MEMCACHED_HOST:-"127.0.0.1"}}
export LIBRENMS_MEMCACHED_PORT=${MEMCACHED_SERVICE_PORT:-${LIBRENMS_MEMCACHED_PORT:-"11211"}}

export LIBRENMS_REDIS_HOST=${REDIS_SERVICE_HOST:-${LIBRENMS_REDIS_HOST:-"127.0.0.1"}}
export LIBRENMS_REDIS_PORT=${REDIS_SERVICE_PORT:-${LIBRENMS_REDIS_PORT:-"6379"}}

