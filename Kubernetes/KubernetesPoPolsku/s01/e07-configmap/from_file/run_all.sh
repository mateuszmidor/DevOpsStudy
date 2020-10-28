#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="alpine-linux-pod"
CONFIG_MAP_NAME="my-config-map"

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

function createConfigMap() {
    stage "Creating config map"
    
    kubectl apply -k . # kustomization

    echo "Done"
}

function runExample() {
    stage "Running example"

    kubectl apply -f objects.yml

    # wait Pod is up
    while [[ `kubectl get pod $POD_NAME -o jsonpath='{ .status.containerStatuses[0].ready }'` != "true" ]]; do 
        echo "waiting..."; 
        sleep 1; 
    done

    echo "Done"
}

function showLogs() {  
    stage "Showing configmap stored as env variables and as files"

    kubectl logs $POD_NAME

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    kubectl delete --grace-period=1 -f objects.yml
    kubectl delete -k .

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
createConfigMap
runExample
showLogs
keepAlive