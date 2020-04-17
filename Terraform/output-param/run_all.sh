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

    cat terraform.tfstate
}

function tearDown() {
    stage "Destroying resources"
    exit 0
}


checkPrerequsites
createResources
printState
tearDown