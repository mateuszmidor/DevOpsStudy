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

    echo "OK"
}

function createResources() {
    stage "Creating droplet resources"

    terraform init
    terraform apply \
        -auto-approve
}

function printState() {
    stage "Print terraform.tfstate"

    terraform output instance_ip_addr # print from terraform.tfstate by keyname
}

function tearDown() {
    stage "Exiting now"
    
    exit 0
}


checkPrerequsites
createResources
printState
tearDown