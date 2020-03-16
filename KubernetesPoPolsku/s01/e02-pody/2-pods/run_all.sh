#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="producer-consumer"

function checkPrerequsites() {
    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1
}

function runMinikube() {
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

function runPod() {
    echo "Running POD"
    sudo kubectl apply -f deployment.yml

    # wait POD is up
    while [[ `sudo kubectl get pod | grep $POD_NAME | grep Running` == "" ]]; do sleep 1; done
}

function showConsumerLogs() {
    # read logs
    sudo kubectl logs producer-consumer -c consumer -f
}

function tearDown() {
    sudo kubectl delete pod $POD_NAME
    exit 0
}

checkPrerequsites
runMinikube
runPod
showConsumerLogs