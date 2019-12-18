#!/bin/bash

docker push tpboudreau/librenms-check-redis
docker push tpboudreau/librenms-check-rrdcached
docker push tpboudreau/librenms-check-memcached
docker push tpboudreau/librenms-check-mysql

docker push tpboudreau/librenms-dispatcher
docker push tpboudreau/librenms-dispatcher-sping
docker push tpboudreau/librenms-application-prepare-volume
docker push tpboudreau/librenms-application-prepare-volume-sping
docker push tpboudreau/librenms-application-php-fpm
docker push tpboudreau/librenms-application-php-fpm-sping
docker push tpboudreau/librenms-application-nginx

docker push tpboudreau/librenms-prepare-mysql
docker push tpboudreau/librenms-cleanup-application
docker push tpboudreau/librenms-validate-application
docker push tpboudreau/librenms-generate-key
#docker push tpboudreau/librenms-update-application
#docker push tpboudreau/librenms-rotate-credentials

docker push tpboudreau/librenms-prepare-mysql-sping
docker push tpboudreau/librenms-cleanup-application-sping
docker push tpboudreau/librenms-validate-application-sping
#docker push tpboudreau/librenms-update-application-sping
#docker push tpboudreau/librenms-rotate-credentials-sping

