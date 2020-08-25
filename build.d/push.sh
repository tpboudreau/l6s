#!/bin/bash

export V=$(cat ./VERSION)
export M=0.1

docker push tpboudreau/librenms-check-redis:${V} && docker push tpboudreau/librenms-check-redis:${M}
docker push tpboudreau/librenms-check-rrdcached:${V} && docker push tpboudreau/librenms-check-rrdcached:${M}
docker push tpboudreau/librenms-check-memcached:${V} && docker push tpboudreau/librenms-check-memcached:${M}
docker push tpboudreau/librenms-check-mysql:${V} && docker push tpboudreau/librenms-check-mysql:${M}

docker push tpboudreau/librenms-dispatcher:${V} && docker push tpboudreau/librenms-dispatcher:${M}
docker push tpboudreau/librenms-application-prepare-volume:${V} && docker push tpboudreau/librenms-application-prepare-volume:${M}
docker push tpboudreau/librenms-application-php-fpm:${V} && docker push tpboudreau/librenms-application-php-fpm:${M}
docker push tpboudreau/librenms-application-nginx:${V} && docker push tpboudreau/librenms-application-nginx:${M}

docker push tpboudreau/librenms-prepare-mysql:${V} && docker push tpboudreau/librenms-prepare-mysql:${M}
docker push tpboudreau/librenms-cleanup-application:${V} && docker push tpboudreau/librenms-cleanup-application:${M}
docker push tpboudreau/librenms-validate-application:${V} && docker push tpboudreau/librenms-validate-application:${M}
docker push tpboudreau/librenms-generate-key:latest
#docker push tpboudreau/librenms-update-application:${V}
#docker push tpboudreau/librenms-rotate-credentials:${V}

docker push tpboudreau/librenms-console:${V} && docker push tpboudreau/librenms-console:${M}
docker push tpboudreau/librenms-device-v2c:${V} && docker push tpboudreau/librenms-device-v2c:${M}
docker push tpboudreau/librenms-device-v3:${V} && docker push tpboudreau/librenms-device-v3:${M}

docker push tpboudreau/librenms-memcached:${V} && docker push tpboudreau/librenms-memcached:${M}
docker push tpboudreau/librenms-mysql:${V} && docker push tpboudreau/librenms-mysql:${M}
docker push tpboudreau/librenms-mysql-prepare-volume:${V} && docker push tpboudreau/librenms-mysql-prepare-volume:${M}
docker push tpboudreau/librenms-redis:${V} && docker push tpboudreau/librenms-redis:${M}
docker push tpboudreau/librenms-rrdcached:${V} && docker push tpboudreau/librenms-rrdcached:${M}
docker push tpboudreau/librenms-subpath:${V} && docker push tpboudreau/librenms-subpath:${M}

