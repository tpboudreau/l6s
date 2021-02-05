#!/bin/bash

export LIBRENMS_WORKDIR=$(pwd)
export LIBRENMS_ARCHIVE=/tmp/librenms.tar.gz

. /services.sh

# TODO: ensure that all expecte ENV variable are set, else exit non-zero

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

if [[ -d /opt/librenms ]]; then
  if [[ -n "$(ls -A /opt/librenms)" ]]; then
    echo $(stamp) "[ERROR] volume mounted at /opt/librenms is not empty"
    exit 1
  else
    echo $(stamp) "[INFO] installing application from archive ${LIBRENMS_ARCHIVE}"
    tar xzf ${LIBRENMS_ARCHIVE} --preserve-permissions --acls --strip-components=2 || exit 2
    chown -R librenms:librenms ${LIBRENMS_WORKDIR}/*

    echo $(stamp) "[INFO] creating default health check"
    rm -f ${LIBRENMS_WORKDIR}/html/healthz
    touch ${LIBRENMS_WORKDIR}/html/healthz

    export LIBRENMS_DISPATCHER_POLLER_NAME=${LIBRENMS_DISPATCHER_POLLER_NAME:-$HOSTNAME}
    export LIBRENMS_DISPATCHER_POLLER_GROUP=${LIBRENMS_DISPATCHER_POLLER_GROUP:-0}
    export LIBRENMS_DISPATCHER_POLLER_WORKERS=${LIBRENMS_DISPATCHER_POLLER_WORKERS:-24}
    export LIBRENMS_DISPATCHER_DISCOVERY_WORKERS=${LIBRENMS_DISPATCHER_DISCOVERY_WORKERS:-16}
    export LIBRENMS_DISPATCHER_SERVICES_WORKERS=${LIBRENMS_DISPATCHER_SERVICES_WORKERS:-8}

    echo $(stamp) "[INFO] setting environment"
    ( envsubst < /tmp/librenms.env > ${LIBRENMS_WORKDIR}/.env && \
      chown librenms:librenms ${LIBRENMS_WORKDIR}/.env && \
      chmod 640 ${LIBRENMS_WORKDIR}/.env ) || exit 3

    echo $(stamp) "[INFO] configuring application"
    ( cat /tmp/librenms.config.php /tmp/librenms.dispatcher.config.php /tmp/librenms.ldap.config.php /tmp/librenms.ad.config.php | \
      envsubst "$(printf '${%s} ' ${!LIBRENMS*})" | \
      grep -v 'LIBRENMS_AUTH_LDAP_' | \
      grep -v 'LIBRENMS_AUTH_AD_' > \
      ${LIBRENMS_WORKDIR}/config.php && \
      chown librenms:librenms ${LIBRENMS_WORKDIR}/config.php && \
      chmod 640 ${LIBRENMS_WORKDIR}/config.php ) || exit 4
  fi
else
  echo $(stamp) "[ERROR] no volume mounted at /opt/librenms"
  exit 5
fi

exit 0

