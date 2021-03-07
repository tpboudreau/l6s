#!/bin/bash

cd ./application.d && ./build.sh && cd ..
cd ./console.d && ./build.sh && cd ..
cd ./device.d && ./build.sh && cd ..
cd ./memcached.d && ./build.sh && cd ..
cd ./mysql.d && ./build.sh && cd ..
cd ./redis.d && ./build.sh && cd ..
cd ./rrdcached.d && ./build.sh && cd ..
cd ./subpath.d && ./build.sh && cd ..

exit

