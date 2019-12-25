#!/bin/bash

docker build -t tpboudreau/librenms-rrdcached:$(cat ../VERSION) .

