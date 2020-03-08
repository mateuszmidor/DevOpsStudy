#!/usr/bin/env bash

Container="mateuszmidor/digitcheck-webapp"

# build image
./build_docker_image.sh

# run
docker run -p 8000:80 $Container &

# wait till http server is up
while true; do curl -X GET localhost:8000/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

# ask server for main page
result_html=`curl -X GET localhost:8000/`

# kill container
docker kill `docker ps | grep $Container | cut -d ' ' -f1`

# empty line for better result readibility
echo

# check result
[[ $? != 0 ]] && echo "webapp sever error" && exit 1
[[ `echo $result_html | grep "<title>DigitCheck</title>"` == "" ]] && echo "webapp test FAIL" && exit 1
echo "webapp test SUCCESS"