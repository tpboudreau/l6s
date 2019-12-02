#!/bin/bash

docker build -t tpboudreau/librenms-controller .

#--- OLD ---

#docker build --build-arg PROVIDER=mysql --build-arg PORT=3306 --build-arg TIMEOUT=480m -t tpboudreau/librenms-mysql-controller .

#docker build --build-arg PROVIDER=rrdcached --build-arg PORT=42217 --build-arg TIMEOUT=5m -t tpboudreau/librenms-rrdcached-controller .

#docker build --build-arg PROVIDER=memcached --build-arg PORT=11211 --build-arg TIMEOUT=5m -t tpboudreau/librenms-memcached-controller .

#docker build --build-arg PROVIDER=redis --build-arg PORT=6379 --build-arg TIMEOUT=5m -t tpboudreau/librenms-redis-controller .

