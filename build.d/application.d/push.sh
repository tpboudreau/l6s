#!/bin/bash

docker push tpboudreau/librenms-check-redis
docker push tpboudreau/librenms-check-rrdcached
docker push tpboudreau/librenms-check-memcached
docker push tpboudreau/librenms-check-mysql

docker push tpboudreau/librenms-dispatcher
docker push tpboudreau/librenms-application-prepare-volume
docker push tpboudreau/librenms-application-php-fpm
docker push tpboudreau/librenms-application-nginx

docker push tpboudreau/librenms-prepare-mysql
docker push tpboudreau/librenms-cleanup-application
docker push tpboudreau/librenms-validate-application
#docker push tpboudreau/librenms-update-application
#docker push tpboudreau/librenms-rotate-credentials
docker push tpboudreau/librenms-generate-key

