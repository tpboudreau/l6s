#!/bin/bash

docker build -t tpboudreau/librenms-check-memcached:$(cat ../../VERSION) .

