#!/bin/env bash

docker run -it -p 3000:3000 -v $(pwd)/ntopng.license:/etc/ntopng.license:ro --net=talker-net ntop/ntopng.dev:latest -i eth0