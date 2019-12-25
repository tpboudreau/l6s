#!/bin/bash

docker build -t tpboudreau/librenms-memcached:$(cat ../VERSION) .

