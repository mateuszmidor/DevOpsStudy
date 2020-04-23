#!/usr/bin/env bash

function stage() {
    COLOR="\e[96m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command go version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install GO compiler to run this example" && exit 1

    command terraform version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install terraform to run this example" && exit 1

    echo "OK"
}

function buildProvider() {
    stage "Building custom provider from GO code"

    pushd plugin/
        # the name is important; must be: terraform-<TYPE>-<NAME>
        go build -o terraform-provider-fibb
    popd
}

function createResources() {
    stage "Creating resources"

    terraform init -plugin-dir=plugin/
    terraform apply -auto-approve
}

function printState() {
    stage "Print terraform.tfstate"

    terraform output fibbResult
}


checkPrerequsites
buildProvider
createResources
printState