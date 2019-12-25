#!/bin/bash

docker build -t tpboudreau/librenms-mysql-prepare-volume:$(cat ../../VERSION) .

