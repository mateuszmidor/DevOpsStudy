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

    command aws-iam-authenticator version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install aws-iam-authenticator to run this example" && exit 1

    echo "OK"
}

function createResources() {
    stage "Creating AWS EKS cluster. This will take ~10 minutes"

    terraform init
    terraform apply -auto-approve
}

function getNodes() {
    stage "Get kubernetes cluster nodes"

    command kubectl > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "You need to install kubectl to see node list" 
    else
        sleep 15 # give some time for nodes to get up
        terraform output kubectl_config > config.yml
        KUBECONFIG=config.yml kubectl get nodes
        # here you could eg:
        # helm install my-wordpress bitnami/wordpress
        # but remember to eventually delete on-demand created volume!
        rm config.yml
    fi
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Destroying AWS EKS resources"

    terraform destroy -auto-approve
    exit 0
}


checkPrerequsites
createResources
getNodes
keepAlive