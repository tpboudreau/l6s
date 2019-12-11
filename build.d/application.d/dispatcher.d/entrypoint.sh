#!/bin/bash

export LIBRENMS_WORKDIR=$(pwd)

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

. /services.sh

if [[ -z "${LIBRENMS_DISPATCHER_POLLER_GROUP}" ]]
then
  echo $(stamp) "[INFO] attempting to determine poller group from hostname"
  export G=$(echo ${HOSTNAME} | sed 's/.*-//')
  LIBRENMS_DISPATCHER_POLLER_GROUP=${G:0}
fi

rx='^[0-9]+$'
if ! [[ ${LIBRENMS_DISPATCHER_POLLER_GROUP} =~ $rx ]]
then
  echo $(stamp) "[WARNING] detected non-numeric poller group value"
  LIBRENMS_DISPATCHER_POLLER_GROUP=0
fi

if [[ -z "${LIBRENMS_DISPATCHER_POLLER_NAME}" ]]
then
  echo $(stamp) "[INFO] assigning poller name using poller group value"
  LIBRENMS_DISPATCHER_POLLER_NAME="dispatcher-${LIBRENMS_DISPATCHER_POLLER_GROUP}"
fi

echo $(stamp) "[INFO] service environment: "
echo 
echo "  LIBRENMS_DISPATCHER_POLLER_GROUP: ${LIBRENMS_DISPATCHER_POLLER_GROUP}"
echo "  LIBRENMS_DISPATCHER_POLLER_NAME: ${LIBRENMS_DISPATCHER_POLLER_NAME}"
echo "  LIBRENMS_MYSQL_HOST: ${LIBRENMS_MYSQL_HOST}"
echo "  LIBRENMS_MYSQL_PORT: ${LIBRENMS_MYSQL_PORT}"
echo "  LIBRENMS_RRDCACHED_HOST: ${LIBRENMS_RRDCACHED_HOST}"
echo "  LIBRENMS_RRDCACHED_PORT: ${LIBRENMS_RRDCACHED_PORT}"
echo "  LIBRENMS_MEMCACHED_HOST: ${LIBRENMS_MEMCACHED_HOST}"
echo "  LIBRENMS_MEMCACHED_PORT: ${LIBRENMS_MEMCACHED_PORT}"
echo "  LIBRENMS_REDIS_HOST: ${LIBRENMS_REDIS_HOST}"
echo "  LIBRENMS_REDIS_PORT: ${LIBRENMS_REDIS_PORT}"
echo 

echo $(stamp) "[INFO] setting environment"
( envsubst < /tmp/librenms.env > ${LIBRENMS_WORKDIR}/.env && chmod 640 ${LIBRENMS_WORKDIR}/.env ) || exit 1
unset $(cat ${LIBRENMS_WORKDIR}/.env | grep '=' | sed s/=.*$//)

echo $(stamp) "[INFO] configuring dispatcher"
( cat /tmp/librenms.config.php /tmp/librenms.dispatcher.config.php | envsubst "$(printf '${%s} ' ${!LIBRENMS*})" > ${LIBRENMS_WORKDIR}/config.php && \
  chmod 640 ${LIBRENMS_WORKDIR}/config.php ) || exit 2

echo $(stamp) "[INFO] starting dispatcher"
exec ./librenms-service.py -t -g ${LIBRENMS_DISPATCHER_POLLER_GROUP} ${LIBRENMS_DISPATCHER_LOG_LEVEL}

