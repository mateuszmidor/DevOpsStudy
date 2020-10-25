#!/usr/bin/env bash

trap tearDown SIGINT

function stage() {
    BOLD_BLUE="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_BLUE$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    echo "Done"
}

function runMinikube() {
    stage "Running minikube"

    host_status=`minikube status -f '{{ .Host }}'`
    kubelet_status=`minikube status -f '{{ .Kubelet }}'`
    apiserver_status=`minikube status -f '{{ .APIServer }}'`
    if [ $host_status != "Running"  ] || [ $kubelet_status != "Running"  ] || [ $apiserver_status != "Running"  ]; then
        minikube stop
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
    firefox $url
    echo "Running web dashboard"
    minikube dashboard | egrep -o http.*
}


function tearDown() {
    stage "Tear down"

    kubectl delete deployment hello-world-deployment
    kubectl delete service hello-world-service

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
createKubernetesResources
showHelloAndDashboard