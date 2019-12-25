#!/bin/bash

docker build -t tpboudreau/librenms-check-redis:$(cat ../../VERSION) .

