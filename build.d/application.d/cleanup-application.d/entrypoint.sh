#!/bin/bash

export LIBRENMS_WORKDIR=$(pwd)

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

. /services.sh

echo $(stamp) "[INFO] cleaning application"

export LIBRENMS_DISPATCHER_POLLER_NAME=${LIBRENMS_DISPATCHER_POLLER_NAME:-$HOSTNAME}
export LIBRENMS_DISPATCHER_POLLER_GROUP=${LIBRENMS_DISPATCHER_POLLER_GROUP:-0}
export LIBRENMS_DISPATCHER_POLLER_WORKERS=${LIBRENMS_DISPATCHER_POLLER_WORKERS:-24}
export LIBRENMS_DISPATCHER_DISCOVERY_WORKERS=${LIBRENMS_DISPATCHER_DISCOVERY_WORKERS:-16}
export LIBRENMS_DISPATCHER_SERVICES_WORKERS=${LIBRENMS_DISPATCHER_SERVICES_WORKERS:-8}

envsubst < /tmp/librenms.env > ${LIBRENMS_WORKDIR}/.env
unset $(cat ${LIBRENMS_WORKDIR}/.env | grep '=' | sed s/=.*$//)
cat /tmp/librenms.config.php /tmp/librenms.dispatcher.config.php | envsubst "$(printf '${%s} ' ${!LIBRENMS*})" > ${LIBRENMS_WORKDIR}/config.php

./daily.sh cleanup

exit $?

