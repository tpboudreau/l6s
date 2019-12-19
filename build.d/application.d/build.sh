#!/bin/bash

export REPO='https://github.com/tpboudreau/librenms/tarball/use_snmp_ping'
export TAG='0.1'

# Appllcation pod images
docker build --build-arg MODE=prepare-volume --build-arg REPO=${REPO} -t tpboudreau/librenms-application-prepare-volume:${TAG} .
docker build --build-arg MODE=check-mysql --build-arg REPO=${REPO} -t tpboudreau/librenms-check-mysql:${TAG} .
docker build --build-arg MODE=application-php-fpm --build-arg REPO=${REPO} -t tpboudreau/librenms-application-php-fpm:${TAG} .

# Job pod images
docker build --build-arg MODE=prepare-mysql --build-arg REPO=${REPO} -t tpboudreau/librenms-prepare-mysql:${TAG} .
docker build --build-arg MODE=cleanup-application --build-arg REPO=${REPO} -t tpboudreau/librenms-cleanup-application:${TAG} .
docker build --build-arg MODE=validate-application --build-arg REPO=${REPO} -t tpboudreau/librenms-validate-application:${TAG} .
#docker build --build-arg MODE=update-application --build-arg REPO=${REPO} -t tpboudreau/librenms-update-application:${TAG} .
#docker build --build-arg MODE=rotate-credentials --build-arg REPO=${REPO} -t tpboudreau/librenms-rotate-credentials:${TAG} .
docker build --build-arg MODE=generate-key --build-arg REPO=${REPO} -t tpboudreau/librenms-generate-key:latest .

# Dispatcher pod images
docker build --build-arg MODE=dispatcher --build-arg REPO=${REPO} -t tpboudreau/librenms-dispatcher:${TAG} .


cd ./nginx.d && ./build.sh && cd ..
cd ./check-memcached.d && ./build.sh && cd ..
cd ./check-redis.d && ./build.sh && cd ..
cd ./check-rrdcached.d && ./build.sh && cd ..

exit

