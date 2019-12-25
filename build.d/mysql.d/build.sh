#!/bin/bash

docker build -t tpboudreau/librenms-mysql:$(cat ../VERSION) .

