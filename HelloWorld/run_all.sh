#!/usr/bin/env bash

trap deleteDeployment SIGINT

function runMinikube() {
    echo "Running minikube"
    sudo rm /tmp/juju-mk*
    sudo minikube start --vm-driver=none
}

function createDeployment() {
    echo "Creating deployment"
    sudo kubectl create -f deployment.yml
}

function deleteDeployment() {
    echo "Deleting deployment"
    sudo kubectl delete deployment hello-world-deployment
    sudo kubectl delete service hello-world-service
    exit 0
}

function showHelloAndDashboard() {
    ip=`sudo minikube ip`

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET $ip:31000/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing Kubernetized Hello World Web App"
    firefox $ip:31000
    echo "Running web dashboard"
    sudo minikube dashboard | egrep -o http.*
}


[[ `sudo minikube status | grep Running` == "" ]] && runMinikube
[[ `sudo minikube status | grep Running` != "" ]] && createDeployment
[[ `sudo kubectl get deployment | grep hello-world-deployment` != "" ]] && showHelloAndDashboard
