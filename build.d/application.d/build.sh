#!/bin/bash

export REPO='https://github.com/tpboudreau/librenms/tarball/use_snmp_ping'
export TAG='0.1'

for PING in 'fping' 'sping';
do
  case ${PING} in 'sping') export SUFFIX='-sping' ;; *) export SUFFIX='' ;; esac
  # Appllcation pod images
  docker build --build-arg MODE=prepare-volume --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-prepare-volume${SUFFIX}:${TAG} .
  docker build --build-arg MODE=application-php-fpm --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-application-php-fpm${SUFFIX}:${TAG} .
  docker build --build-arg MODE=check-mysql --build-arg REPO=${REPO} --build-arg PING=sping -t tpboudreau/librenms-check-mysql:${TAG} .
  # Job pod images
  docker build --build-arg MODE=prepare-mysql --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-prepare-mysql${SUFFIX}:${TAG} .
  docker build --build-arg MODE=cleanup-application --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-cleanup-application${SUFFIX}:${TAG} .
  docker build --build-arg MODE=validate-application --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-validate-application${SUFFIX}:${TAG} .
  #docker build --build-arg MODE=update-application --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-update-application${SUFFIX}:${TAG} .
  #docker build --build-arg MODE=rotate-credentials --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-rotate-credentials${SUFFIX}:${TAG} .
  # Dispatcher pod images
  docker build --build-arg MODE=dispatcher --build-arg REPO=${REPO} --build-arg PING=${PING} -t tpboudreau/librenms-dispatcher${SUFFIX}:${TAG} .
done

cd ./nginx.d && ./build.sh && cd ..
cd ./check-memcached.d && ./build.sh && cd ..
cd ./check-redis.d && ./build.sh && cd ..
cd ./check-rrdcached.d && ./build.sh && cd ..

exit

