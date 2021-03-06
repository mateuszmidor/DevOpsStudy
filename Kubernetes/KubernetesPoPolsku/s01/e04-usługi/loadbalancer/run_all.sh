#!/usr/bin/env bash

trap tearDown SIGINT

REPLICASET_NAME="hello-world-replicaset"
SERVICE_NAME="hello-world-service"

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

    command socat -h > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install socat for port forwarding" && exit 1

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

function runReplicaSetAndService() {
    stage "Creating ReplicaSet and Service"

    kubectl apply -f replicaset_service.yml

    # wait ReplicaSet is up
    while [[ `kubectl get replicaset $REPLICASET_NAME -o jsonpath='{ .status.readyReplicas }'` != "3" ]]; do 
        echo "waiting..."; 
        sleep 1; 
    done

    echo
    kubectl get replicaset

    echo
    kubectl get services

    echo "You can use: 'minikube tunnel' to get external IP assigned to LoadBalancer"
    echo "Done"
}

function showWebPage() {
    stage "Showing web page"

    ip=`minikube ip`
    port="31000" # configured in deployment.yaml

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET --max-time 1 $ip:$port/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing Kubernetized Hello World Web App"
    firefox $ip:$port
    
    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    kubectl delete service $SERVICE_NAME
    kubectl delete replicaset $REPLICASET_NAME

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
runReplicaSetAndService
showWebPage
keepAlive