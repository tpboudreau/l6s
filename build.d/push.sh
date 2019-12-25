#!/bin/bash

export V=$(cat ./VERSION)

docker push tpboudreau/librenms-check-redis:${V}
docker push tpboudreau/librenms-check-rrdcached:${V}
docker push tpboudreau/librenms-check-memcached:${V}
docker push tpboudreau/librenms-check-mysql:${V}

docker push tpboudreau/librenms-dispatcher:${V}
docker push tpboudreau/librenms-application-prepare-volume:${V}
docker push tpboudreau/librenms-application-php-fpm:${V}
docker push tpboudreau/librenms-application-nginx:${V}

docker push tpboudreau/librenms-prepare-mysql:${V}
docker push tpboudreau/librenms-cleanup-application:${V}
docker push tpboudreau/librenms-validate-application:${V}
#docker push tpboudreau/librenms-update-application:${V}
#docker push tpboudreau/librenms-rotate-credentials:${V}
docker push tpboudreau/librenms-generate-key:latest

docker push tpboudreau/librenms-console:${V}
docker push tpboudreau/librenms-device-v2c:${V}
docker push tpboudreau/librenms-device-v3:${V}

docker push tpboudreau/librenms-memcached:${V}
docker push tpboudreau/librenms-mysql:${V}
docker push tpboudreau/librenms-mysql-prepare-volume:${V}
docker push tpboudreau/librenms-redis:${V}
docker push tpboudreau/librenms-rrdcached:${V}
docker push tpboudreau/librenms-subpath:${V}

