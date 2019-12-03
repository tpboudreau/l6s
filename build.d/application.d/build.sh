#!/bin/bash

# Appllcation pod images
#docker build --build-arg MODE=check-mysql -t tpboudreau/librenms-check-mysql .
#docker build --build-arg MODE=prepare-volume -t tpboudreau/librenms-application-prepare-volume .
#docker build --build-arg MODE=application-php-fpm -t tpboudreau/librenms-application-php-fpm .

# Job pod images
#docker build --build-arg MODE=prepare-mysql -t tpboudreau/librenms-prepare-mysql .
#docker build --build-arg MODE=cleanup-application -t tpboudreau/librenms-cleanup-application .
#docker build --build-arg MODE=validate-application -t tpboudreau/librenms-validate-application .
#docker build --build-arg MODE=update-application -t tpboudreau/librenms-update-application .
#docker build --build-arg MODE=rotate-credentials -t tpboudreau/librenms-rotate-credentials .

# Dispacther pod images
docker build --build-arg MODE=dispatcher -t tpboudreau/librenms-dispatcher .

