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

    [[ -z $DO_TOKEN ]] && echo "You need to export variable DO_TOKEN first" && exit 1

    command terraform version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install terraform to run this example" && exit 1

    echo "OK"
}

function createResources() {
    stage "Creating cluster. This will take ~7 minutes"

    terraform init
    terraform apply \
        -auto-approve \
        -var "do_token=$DO_TOKEN"
}

function getNodes() {
    stage "Get kubernetes cluster nodes"

    command kubectl > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "You need to install kubectl to see node list" 
    else
        python get_kubeconfig.py > config.yml
        KUBECONFIG=config.yml kubectl get nodes
        rm config.yml
    fi
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Destroying digitalocean resources"

    terraform destroy \
        -auto-approve \
        -var "do_token=$DO_TOKEN"
    exit 0
}


checkPrerequsites
createResources
getNodes
keepAlive