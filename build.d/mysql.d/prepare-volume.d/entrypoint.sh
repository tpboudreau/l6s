#!/bin/bash

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

if [[ -d /configuration && -n "$(ls -A /configuration/*.cnf 2> /dev/null)" ]]; then
  echo $(stamp) "detected database configuration file"
else
  echo $(stamp) "installing database configuration file"
  cp /tmp/librenms.cnf /configuration/librenms.cnf
  chmod 644 /configuration/librenms.cnf
fi

if [[ -d /database && -n "$(ls -A /database)" ]]; then
  echo $(stamp) "detected populated database"
else
  if [[ -d /initialization && -n "$(ls -A /initialization/*.{sh,sql,sql.gz} 2> /dev/null)" ]]; then
    echo $(stamp) "detected restorable database"
  else
    echo $(stamp) "detected unpopulated database"
    cp /tmp/alter.sql /initialization/alter.sql
    chmod 644 /initialization/alter.sql
  fi
fi

exit 0

