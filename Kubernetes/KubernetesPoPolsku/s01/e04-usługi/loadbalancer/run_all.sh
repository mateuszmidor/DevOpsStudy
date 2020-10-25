#!/usr/bin/env bash

trap tearDown SIGINT

REPLICASET_NAME="hello-world-replicaset"
SERVICE_NAME="hello-world-service"

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

function runReplicaSetAndService() {
    echo "Running ReplicaSet and Service"
    sudo kubectl apply -f deployment.yml

    # wait replicaset is up
    while [[ `sudo kubectl get replicaset | grep $REPLICASET_NAME` == "" ]]; do sleep 1; done

    # wait pod is up. Pod name is replicaset name + some id
    while [[ `sudo kubectl get pods | grep $REPLICASET_NAME | grep Running` == "" ]]; do sleep 1; done

    echo
    sudo kubectl get replicaset

    echo
    sudo kubectl get services

    echo
}

function showWebPage() {
    ip=`sudo minikube ip`
    port="31000" # configured in deployment.yaml

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET --max-time 1 $ip:$port/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing Kubernetized Hello World Web App"
    firefox $ip:$port
    
    while true; do sleep 1; done
}

function tearDown() {
    sudo kubectl delete service $SERVICE_NAME
    sudo kubectl delete replicaset $REPLICASET_NAME
    exit 0
}

checkPrerequsites
runMinikube
runReplicaSetAndService
showWebPage