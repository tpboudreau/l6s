#!/bin/bash

docker build -t tpboudreau/librenms-check-rrdcached:$(cat ../../VERSION) .

