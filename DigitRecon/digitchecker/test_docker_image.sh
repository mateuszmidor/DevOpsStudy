#!/usr/bin/env bash

Container="mateuszmidor/digitrecon-digitchecker"
Input="test_seven.png"
ExpectedOutput='{"value": "7"}'

# build image
./build_docker_image.sh

# run server
docker run -p 8000:80 -v /tmp:/tmp $Container &

# wait till http server is up
while true; do curl -X GET localhost:8000/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

# send greyscale 28x28x8bit image to server for digit recognition
result=`curl -X POST --data-binary @$Input localhost:8000/checkdigit`

# kill container
docker kill `docker ps | grep $Container | cut -d ' ' -f1`

# newline for better result readibility
echo

# check result
[[ $? != 0 ]] && echo "digitchecker server error." && exit 1
[[ $result != $ExpectedOutput ]] && echo "digitchecker test FAIL: $result != $ExpectedOutput" && exit 1
echo "digitchecker test SUCCESS"
