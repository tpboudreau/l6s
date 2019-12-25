#!/bin/bash

docker build -t tpboudreau/librenms-application-nginx:$(cat ../../VERSION) .

