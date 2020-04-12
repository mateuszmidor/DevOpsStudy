#!/usr/bin/env bash

trap tearDown SIGINT

HOST1="linux1"
HOST2="linux2"

function stage() {
    COLOR="\e[95m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command docker --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install docker to run this example" && exit 1

    command ansible --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install ansible to run this example" && exit 1

    echo "OK"
}

function runContainers() {
    stage "Running containers $HOST1, $HOST2 as daemons"
 
    # sleep 60, so the container doesnt die immediately
    docker run --name $HOST1 --rm -d alpine sleep 60
    docker run --name $HOST2 --rm -d alpine sleep 60
}


function runAnsible() {
    stage "Running ansible"

    ansible-playbook run.yaml
}

function tearDown() {
    stage "Destroying containers"

    docker kill $HOST1
    docker kill $HOST2
    exit 0
}


checkPrerequsites
runContainers
runAnsible
tearDown