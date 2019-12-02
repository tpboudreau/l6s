#!/bin/sh

if [[ -z "${LIBRENMS_ADMINISTRATIVE_ADDRESSES}" ]]; then
  true
else
  export F="/nginx/whitelist.conf"
  export A=${LIBRENMS_ADMINISTRATIVE_ADDRESSES:-"127.0.0.1"}
  rm -f ${F}
  touch ${F}
  chmod 644 ${F}
  echo ${A} | sed -n 1'p' | tr ',' '\n' | while read a; do
    case "${a}" in
    '0.0.0.0')
      echo "allow 127.0.0.1;" >> ${F}
      ;;
    '0.0.0.0/0')
      echo "allow all;" >> ${F}
      ;;
    *)
      echo "allow ${a};" >> ${F}
      ;;
    esac
  done
  echo "deny all;" >> ${F}
fi

exec nginx

