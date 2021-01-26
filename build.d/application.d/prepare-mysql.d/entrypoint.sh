#!/bin/bash

export LIBRENMS_WORKDIR=$(pwd)

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

. /services.sh

TABLE_COUNT=$(mysql -h ${LIBRENMS_MYSQL_HOST} -u ${LIBRENMS_MYSQL_USER} -p${LIBRENMS_MYSQL_PASSWORD} < /count_tables.sql | tail -1)

if (( TABLE_COUNT > 0 )); then
  echo $(stamp) "[ERROR] database is already populated"
  exit 1
else
  echo $(stamp) "[INFO] populating database"

  export LIBRENMS_MYSQL_DATABASE=${LIBRENMS_MYSQL_DATABASE:-'librenms'}
  export LIBRENMS_MEMORY_LIMIT=${LIBRENMS_MEMORY_LIMIT:-256}
  export LIBRENMS_BASE_URL=${LIBRENMS_BASE_URL:-'http://localhost/'}

  export LIBRENMS_DISPATCHER_POLLER_NAME=${LIBRENMS_DISPATCHER_POLLER_NAME:-$HOSTNAME}
  export LIBRENMS_DISPATCHER_POLLER_GROUP=${LIBRENMS_DISPATCHER_POLLER_GROUP:-0}
  export LIBRENMS_DISPATCHER_POLLER_WORKERS=${LIBRENMS_DISPATCHER_POLLER_WORKERS:-24}
  export LIBRENMS_DISPATCHER_DISCOVERY_WORKERS=${LIBRENMS_DISPATCHER_DISCOVERY_WORKERS:-16}
  export LIBRENMS_DISPATCHER_SERVICES_WORKERS=${LIBRENMS_DISPATCHER_SERVICES_WORKERS:-8}

  ( envsubst < /tmp/librenms.env > ${LIBRENMS_WORKDIR}/.env && \
    chown librenms:librenms ${LIBRENMS_WORKDIR}/.env && \
    chmod 640 ${LIBRENMS_WORKDIR}/.env ) || exit 2
  unset $(cat ${LIBRENMS_WORKDIR}/.env | grep '=' | sed s/=.*$//)

  ( cat /tmp/librenms.config.php /tmp/librenms.dispatcher.config.php | envsubst "$(printf '${%s} ' ${!LIBRENMS*})" > ${LIBRENMS_WORKDIR}/config.php && \
    chown librenms:librenms ${LIBRENMS_WORKDIR}/config.php && \
    chmod 640 ${LIBRENMS_WORKDIR}/config.php ) || exit 3

  php ./includes/sql-schema/update.php || exit 4

  if [ -z "${LIBRENMS_ADMINISTRATIVE_USER}" ] || [ -z "${LIBRENMS_ADMINISTRATIVE_PASSWORD}" ]; then
    echo $(stamp) "[ERROR] both LIBRENMS_ADMINISTRATIVE_USER and LIBRENMS_ADMINISTRATIVE_PASSWORD must be provided as environment variables"
    exit 5
  else
    echo $(stamp) "[INFO] adding user ${LIBRENMS_ADMINISTRATIVE_USER}"
    php ./adduser.php ${LIBRENMS_ADMINISTRATIVE_USER} ${LIBRENMS_ADMINISTRATIVE_PASSWORD} 10 ${LIBRENMS_ADMINISTRATIVE_EMAIL} || exit 6
  fi
fi

exit 0

