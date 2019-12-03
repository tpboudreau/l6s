#!/bin/sh

#set -x 

alias stamp='date --utc "+[%FT%T]"'

LOCATION=${1:-"/haproxy"}

export HAPROXY_INACTIVITY_TIMEOUT=${HAPROXY_INACTIVITY_TIMEOUT:-"5m"}

if [ ${HAPROXY_FRONTEND_PORT:-"frontend_port_not_set"} = "frontend_port_not_set" ]
then
  echo $(stamp) "[ERROR] environment variable HAPROXY_FRONTEND_PORT must be provided"
  exit 1
fi

if [ ${HAPROXY_PROXY_PORT:-"proxy_port_not_set"} = "proxy_port_not_set" ]
then
  echo $(stamp) "[ERROR] environment variable HAPROXY_PROXY_PORT must be provided"
  exit 1
fi

if [ ${HAPROXY_BACKEND_PROVIDER:-"backend_provider_not_set"} = "backend_provider_not_set" ]
then
  echo $(stamp) "[ERROR] environment variable HAPROXY_BACKEND_PROVIDER must be provided"
  exit 2
fi

separate()
{
  F=${LOCATION}/${2}_addresses
  case "${1}" in
  '')
    ;;
  *)
    rm -f ${F}
    touch ${F}
    chmod 644 ${F}
    A=${1}
    echo ${A} | sed -n 1'p' | tr ',' '\n' | while read a; do
      case "${a}" in
      '0.0.0.0')
        echo '127.0.0.0/8' >> ${F}
        ;;
      '0.0.0.0/0')
        echo 'always_true' > ${LOCATION}/accept_all
        ;;
      *)
        echo ${a} >> ${F}
        ;;
      esac
    done
  esac
}

echo 'always_false' > ${LOCATION}/accept_all
separate "${HAPROXY_WHITELIST_ADDRESSES}" "whitelist"
export HAPROXY_ACCEPT_ALL=$(cat ${LOCATION}/accept_all)

echo $(stamp) "[INFO] process environment: "
echo 
echo "  HAPROXY_BACKEND_PROVIDER: ${HAPROXY_BACKEND_PROVIDER}"
echo "  HAPROXY_FRONTEND_PORT: ${HAPROXY_FRONTEND_PORT}"
echo "  HAPROXY_PROXY_PORT: ${HAPROXY_PROXY_PORT}"
echo "  HAPROXY_INACTIVITY_TIMEOUT: ${HAPROXY_INACTIVITY_TIMEOUT}"
echo "  HAPROXY_ACCEPT_ALL: ${HAPROXY_ACCEPT_ALL}"
echo "  acceptable addresses: $(cat ${LOCATION}/whitelist_addresses | tr '\n' ' ')"
echo "  HAPROXY_LOG_LEVEL: ${HAPROXY_LOG_LEVEL}"
echo 

envsubst < ${LOCATION}/haproxy.cfg.template > ${LOCATION}/haproxy.cfg

exec haproxy -W -db -f /haproxy/haproxy.cfg ${HAPROXY_LOG_LEVEL}

