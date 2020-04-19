#!/usr/bin/env bash

trap tearDown SIGINT


function stage() {
    COLOR="\e[96m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command terraform version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install terraform to run this example" && exit 1

    command aws --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install aws cli to run this example" && exit 1
    
    echo "OK"
}

function createResources() {
    stage "Creating EC2 resources"

    terraform init
    terraform apply -auto-approve
}

function printDNS() {
    stage "Instance created:"

    terraform output dns
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Destroying EC2 resources"

    terraform destroy -auto-approve
    exit 0
}


checkPrerequsites
createResources
printDNS
keepAlive