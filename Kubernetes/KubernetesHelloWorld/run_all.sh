#!/usr/bin/env bash

trap tearDown SIGINT

function stage() {
    BOLD_BLUE="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_BLUE$msg$RESET"
}

function runMinikube() {
    stage "Running minikube"

    if [[ `minikube status | grep Running` == "" ]]; then
        minikube start
        [[ $? != 0 ]] && echo "Running minikube failed" && exit 1
    fi
    echo "Done"
}

function createKubernetesResources() {
    stage "Creating kubernetes resources"

    kubectl create -f deployment_service.yml
    [[ $? != 0 ]] && echo "Creating kubernetes resources failed" && exit 1
    echo "Done"
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


function tearDown() {
    stage "Deleting kubernetes resources"

    kubectl delete deployment hello-world-deployment
    kubectl delete service hello-world-service
    exit 0
}

runMinikube
createKubernetesResources
showHelloAndDashboard