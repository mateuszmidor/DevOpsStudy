#!/usr/bin/env bash

Container="mateuszmidor/digitrecon-pngconverter"
Input="test_input.png"
Output="test_output.png"

# build image
./build_docker_image.sh

# run
docker run -p 8000:81 $Container &

# wait till http server is up
while true; do curl -X GET localhost:8000/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

# send image to server for conversion
curl -X POST --data-binary @$Input localhost:8000/convertpng --output $Output

# kill container
docker kill `docker ps | grep $Container | cut -d ' ' -f1`

# empty line for better result readibility
echo

# check result
[[ $? != 0 ]] && echo "pngconverter sever error" && exit 1
[[ `file $Output | grep "28 x 28, 8-bit"` == "" ]] && echo "pngconveter test FAIL: `file $Output`" && exit 1
echo "pngconveter test SUCCESS"
