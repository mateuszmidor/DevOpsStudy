#!/usr/bin/env bash

counter=1
while true; do
    echo "Server counting: $counter" >> server.log
    ((counter+=1))
    sleep 1
done;