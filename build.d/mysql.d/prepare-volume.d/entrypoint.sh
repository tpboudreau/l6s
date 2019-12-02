#!/bin/bash

shopt -s expand_aliases
alias stamp='date --utc "+[%FT%T]"'

#TODO: exit non-zero if error

if [[ -d /etc/mysql/conf.d && -n "$(ls -A /etc/mysql/conf.d/*.cnf 2> /dev/null)" ]]; then
  echo $(stamp) "detected database configuration file"
else
  echo $(stamp) "installing database configuration file"
  cp /librenms.cnf /etc/mysql/conf.d/
fi

if [[ -d /var/lib/mysql && -n "$(ls -A /var/lib/mysql)" ]]; then
  echo $(stamp) "detected populated database"
else
  if [[ -d /docker-entrypoint-initdb.d && -n "$(ls -A /docker-entrypoint-initdb.d/*.{sh,sql,sql.gz} 2> /dev/null)" ]]; then
    echo $(stamp) "detected restorable database"
  else
    echo $(stamp) "detected unpopulated database"
    cp /alter.sql /docker-entrypoint-initdb.d/
  fi
fi

exit 0

