#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="hostpath-pod"

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

function runExample() {
    stage "Runnig pod"

    kubectl apply -f objects.yml

    # POD conditions: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-conditions
    kubectl wait pod/$POD_NAME --for condition=Ready --timeout=30s 

    echo "Done"
}

function showLogs() {
    stage "Printing pod logs"
    
    kubectl logs $POD_NAME -f

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    kubectl delete pod $POD_NAME

    echo "Done."
    exit 0
}

checkPrerequsites
runMinikube

runExample
showLogs
keepAlive