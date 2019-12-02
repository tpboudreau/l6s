#!/bin/sh

. /services.sh

export REDISCLI_AUTH=${LIBRENMS_REDIS_PASSWORD}

#TODO check for PONG in result (auth failure returns $? == 0)

exec redis-cli -h ${LIBRENMS_REDIS_HOST} -p ${LIBRENMS_REDIS_PORT} -r 4 -i 0.25 ping

