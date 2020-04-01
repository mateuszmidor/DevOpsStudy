#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="alpine-linux-pod"

function stage() {
    GREEN="\e[92m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$GREEN$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    echo "OK"
}

function runMinikube() {
    stage "Running Minikube"

    desired_status=": Running : Running : Running : Configured "
    if [[ `sudo minikube status | egrep -o ":.*" | tr '\n' ' '` != $desired_status ]]; then
        sudo rm -f /tmp/juju-mk*
        sudo minikube stop
        sudo rm -f /tmp/juju-mk*
        echo "Running minikube"
        sudo minikube start --vm-driver=none
    else
        echo "Minikube is running"
    fi

    ip=`sudo minikube ip`
    echo "Your ClusterIP: $ip"
}

function createSecret() {
    stage "Creating secret"
    
    sudo kubectl apply -k . # kustomization
}

function runExample() {
    stage "Running example"

    sudo kubectl apply -f objects.yml

    echo "waiting example running..."
    while [[ `sudo kubectl get pod | grep $POD_NAME | grep Running` == "" ]]; do sleep 1; done
}

function showLogs() {  
    stage "Showing secrets stored as env variables and as files"

    sudo kubectl logs $POD_NAME
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    sudo kubectl delete --grace-period=1 -f objects.yml
    sudo kubectl delete -k .
    exit 0
}

checkPrerequsites
runMinikube
createSecret
runExample
showLogs
keepAlive