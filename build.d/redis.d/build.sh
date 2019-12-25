#!/bin/bash

docker build -t tpboudreau/librenms-redis:$(cat ../VERSION) .

