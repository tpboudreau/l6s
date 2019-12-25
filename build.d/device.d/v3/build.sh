#!/bin/bash

docker build -t tpboudreau/librenms-device-v3:$(cat ../../VERSION) .

