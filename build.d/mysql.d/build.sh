#!/bin/bash

docker build -t tpboudreau/librenms-mysql:$(cat ../VERSION) .

cd ./prepare-volume.d && ./build.sh && cd ..

