#!/bin/bash

docker build -t tpboudreau/librenms-console:$(cat ../VERSION) .

