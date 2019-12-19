#!/bin/sh

V='/volume'
if [ -n "${SUBPATHS}" ]
then
  for S in $(echo ${SUBPATHS} | tr '|' ' '); do
    echo "[NOTICE] creating subpath directory ${V}/${S}"
    mkdir -p ${V}/${S}
  done
  O=${OWNER:-$(id -u)}
  G=${GROUP:-$(id -g)}
  echo "[NOTICE] changing ownership to ${O}:${G}"
  chown -R ${O}:${G} ${V}
  chmod -R 777 ${V}
fi

exit

