#!/bin/bash

docker build -t tpboudreau/librenms-device-v2c:$(cat ../../VERSION) .

