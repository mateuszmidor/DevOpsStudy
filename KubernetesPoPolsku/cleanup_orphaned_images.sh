#!/usr/bin/env bash

# kill stopped containers
docker rm  $(docker ps -q -a)

# remove orphaned images
docker images > /tmp/images
while IFS= read -r line
do
  repo=`echo $line | cut -d ' ' -f1 `
  image=`echo $line | cut -d ' ' -f3 `
  if [ $repo == "<none>" ]; then
    echo "removing image $image"
    docker image rm $image
  fi
done < "/tmp/images"