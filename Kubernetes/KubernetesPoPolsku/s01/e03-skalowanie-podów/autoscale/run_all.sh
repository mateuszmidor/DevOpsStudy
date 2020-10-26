#!/usr/bin/env bash

trap tearDown SIGINT

HPA_NAME="hello-world-hpa"
REPLICASET_NAME="hello-world-replicaset"

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
    stage "Running minikube with pod autoscaling delay set to 15 seconds"

    minikube stop
    minikube start \
        — extra-config=controller-manager.horizontal-pod-autoscaler-upscale-delay=15s \
        — extra-config=controller-manager.horizontal-pod-autoscaler-downscale-delay=15s \
        — extra-config=controller-manager.horizontal-pod-autoscaler-sync-period=10s \
        — extra-config=controller-manager.horizontal-pod-autoscaler-downscale-stabilization=1m
    [[ $? != 0 ]] && echo "Running minikube failed" && exit 1

    echo "Done"
}

function configMetricsServer() {
    stage "Configure metrics server"

    if [[ `minikube addons list | grep metrics-server | grep enabled` == "" ]]; then
        echo "Minikube metrics-server is not running. Run now..."
        minikube addons enable metrics-server
        echo "Check in minikube dashboard if metrics are available"
    fi

    echo "Done"
}

function createReplicaSet() {
    stage "Creating ReplicaSet and Horizontal Pod Autoscaler"
    
    kubectl apply -f replicaset.yml

    # wait ReplicaSet is up
    while [[ `kubectl get replicaset $REPLICASET_NAME -o jsonpath='{ .status.readyReplicas }'` != "1" ]]; do 
        echo "waiting..."; 
        sleep 1; 
    done
    
    echo "Done"
}

function autoscaleReplicaSet() {
    stage "Autoscale ReplicaSet"

    echo "Waiting for autoscale with max num replicase = 3 based on cpu usage vs requested cpu > 50%. It can take a few minutes"

    while true; do 
        kubectl get hpa
        sleep 3
        echo
    done
}

function tearDown() {
    stage "Tear down"

    kubectl delete hpa $HPA_NAME
    kubectl delete replicaset $REPLICASET_NAME

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
configMetricsServer
createReplicaSet
autoscaleReplicaSet