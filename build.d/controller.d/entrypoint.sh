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
        if [ ${2} = 'blacklist' ]
	then
          echo 'always_true' > ${LOCATION}/reject_all
        fi
        if [ ${2} = 'whitelist' ]
	then
          echo 'always_true' > ${LOCATION}/accept_all
        fi
        ;;
      *)
        echo ${a} >> ${F}
        ;;
      esac
    done
  esac
}

echo 'always_false' > ${LOCATION}/reject_all
echo 'always_false' > ${LOCATION}/accept_all
separate "${HAPROXY_BLACKLIST_ADDRESSES}" "blacklist"
separate "${HAPROXY_GATEWAY_ADDRESSES}" "gateway"
separate "${HAPROXY_WHITELIST_ADDRESSES}" "whitelist"
cat ${LOCATION}/whitelist_addresses ${LOCATION}/gateway_addresses > ${LOCATION}/acceptable_addresses

export HAPROXY_REJECT_ALL=$(cat ${LOCATION}/reject_all)
export HAPROXY_ACCEPT_ALL=$(cat ${LOCATION}/accept_all)

echo $(stamp) "[INFO] process environment: "
echo 
echo "  HAPROXY_BACKEND_PROVIDER: ${HAPROXY_BACKEND_PROVIDER}"
echo "  HAPROXY_FRONTEND_PORT: ${HAPROXY_FRONTEND_PORT}"
echo "  HAPROXY_INACTIVITY_TIMEOUT: ${HAPROXY_INACTIVITY_TIMEOUT}"
echo "  gateway addresses: $(cat ${LOCATION}/gateway_addresses | tr '\n' ' ')"
echo "  HAPROXY_REJECT_ALL: ${HAPROXY_REJECT_ALL}"
echo "  rejectable addresses: $(cat ${LOCATION}/blacklist_addresses | tr '\n' ' ')"
echo "  HAPROXY_ACCEPT_ALL: ${HAPROXY_ACCEPT_ALL}"
echo "  acceptable addresses: $(cat ${LOCATION}/acceptable_addresses | tr '\n' ' ')"
echo "  HAPROXY_LOG_LEVEL: ${HAPROXY_LOG_LEVEL}"
echo 

envsubst < ${LOCATION}/haproxy.cfg.template > ${LOCATION}/haproxy.cfg

exec haproxy -W -db -f /haproxy/haproxy.cfg ${HAPROXY_LOG_LEVEL}

