#!/bin/bash

export LIBRENMS_WORKDIR=$(pwd)

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

. /services.sh

#FIXME -- run this switch only of K8S deploys:
#export G=$(echo ${HOSTNAME} | sed 's/.*-//')
#export N="cluster-dispatcher-${G}"

echo $(stamp) "[INFO] service environment: "
echo 
echo "  LIBRENMS_DISPATCHER_POLLER_NAME: ${LIBRENMS_DISPATCHER_POLLER_NAME}"
echo "  LIBRENMS_DISPATCHER_POLLER_GROUP: ${LIBRENMS_DISPATCHER_POLLER_GROUP}"
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

