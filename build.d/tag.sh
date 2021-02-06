#!/bin/bash

export V=$(cat ./VERSION)
export M=0.1

docker tag tpboudreau/librenms-check-redis:${V} tpboudreau/librenms-check-redis:${M}
docker tag tpboudreau/librenms-check-rrdcached:${V} tpboudreau/librenms-check-rrdcached:${M}
docker tag tpboudreau/librenms-check-memcached:${V} tpboudreau/librenms-check-memcached:${M}
docker tag tpboudreau/librenms-check-mysql:${V} tpboudreau/librenms-check-mysql:${M}

docker tag tpboudreau/librenms-dispatcher:${V} tpboudreau/librenms-dispatcher:${M}
docker tag tpboudreau/librenms-application-prepare-mysql:${V} tpboudreau/librenms-application-prepare-mysql:${M}
docker tag tpboudreau/librenms-application-prepare-volume:${V} tpboudreau/librenms-application-prepare-volume:${M}
docker tag tpboudreau/librenms-application-php-fpm:${V} tpboudreau/librenms-application-php-fpm:${M}
docker tag tpboudreau/librenms-application-nginx:${V} tpboudreau/librenms-application-nginx:${M}

docker tag tpboudreau/librenms-cleanup-application:${V} tpboudreau/librenms-cleanup-application:${M}
docker tag tpboudreau/librenms-validate-application:${V} tpboudreau/librenms-validate-application:${M}
#docker tag tpboudreau/librenms-update-application:${V} tpboudreau/librenms-update-application:${M}
#docker tag tpboudreau/librenms-rotate-credentials:${V} tpboudreau/librenms-rotate-credentials:${M}

docker tag tpboudreau/librenms-console:${V} tpboudreau/librenms-console:${M}
docker tag tpboudreau/librenms-device-v2c:${V} tpboudreau/librenms-device-v2c:${M}
docker tag tpboudreau/librenms-device-v3:${V} tpboudreau/librenms-device-v3:${M}

docker tag tpboudreau/librenms-memcached:${V} tpboudreau/librenms-memcached:${M}
docker tag tpboudreau/librenms-mysql:${V} tpboudreau/librenms-mysql:${M}
docker tag tpboudreau/librenms-mysql-prepare-volume:${V} tpboudreau/librenms-mysql-prepare-volume:${M}
docker tag tpboudreau/librenms-redis:${V} tpboudreau/librenms-redis:${M}
docker tag tpboudreau/librenms-rrdcached:${V} tpboudreau/librenms-rrdcached:${M}
docker tag tpboudreau/librenms-subpath:${V} tpboudreau/librenms-subpath:${M}

