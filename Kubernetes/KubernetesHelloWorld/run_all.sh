#!/usr/bin/env bash

trap deleteDeployment SIGINT

function stage() {
    BLUE_BOLD="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BLUE_BOLD$msg$RESET"
}

function runMinikube() {
    stage "Running minikube"

    # rm -f /tmp/juju-mk*
    minikube start # --vm-driver=none; for running minikube inside windows hyper-v
}

function createDeployment() {
    stage "Creating deployment"

    kubectl create -f deployment.yml
}

function deleteDeployment() {
    stage "Deleting deployment"

    kubectl delete deployment hello-world-deployment
    kubectl delete service hello-world-service
    exit 0
}

function showHelloAndDashboard() {
    stage "Displaying Hello webpage and minikube dashboard"

    ip=`minikube ip`
    url="$ip:31000"

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET --max-time 1 $url > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing Kubernetized Hello World Web App"
    firefox $ip:31000
    echo "Running web dashboard"
    minikube dashboard | egrep -o http.*
}


[[ `minikube status | grep Running` == "" ]] && runMinikube
[[ `minikube status | grep Running` != "" ]] && createDeployment
[[ `kubectl get deployment | grep hello-world-deployment` != "" ]] && showHelloAndDashboard
