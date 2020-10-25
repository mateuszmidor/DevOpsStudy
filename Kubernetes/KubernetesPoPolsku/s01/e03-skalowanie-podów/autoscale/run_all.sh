#!/usr/bin/env bash

trap tearDown SIGINT

HPA_NAME="hello-world-hpa"
REPLICASET_NAME="hello-world-replicaset"

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

function configMetricsServer() {
    if [[ `sudo minikube addons list | grep metrics-server | grep enabled` == "" ]]; then
        echo "Minikube metrics-server is not running. Run now..."
        sudo minikube addons enable metrics-server
        echo "Done. Check in minikube dashboard if metrics are available"
    else
        echo "Minikube metrics-server is running"
    fi
}

function runReplicaSet() {
    echo "Running ReplicaSet"
    sudo kubectl apply -f deployment.yml

    # wait replicaset is up
    while [[ `sudo kubectl get replicaset | grep $REPLICASET_NAME` == "" ]]; do sleep 1; done

    # wait pod is up. Pod name is replicaset name + some id
    while [[ `sudo kubectl get pods | grep $REPLICASET_NAME | grep Running` == "" ]]; do sleep 1; done
}

function autoscaleReplicaSet() {
    echo "Waiting for autoscale with max num replicase = 3 based on cpu usage > 50%. It can take a few minutes"

    while true; do 
        sudo kubectl get hpa
        echo
        sleep 3
    done
}

function tearDown() {
    sudo kubectl delete hpa $HPA_NAME
    sudo kubectl delete replicaset $REPLICASET_NAME
    exit 0
}

checkPrerequsites
runMinikube
configMetricsServer
runReplicaSet
autoscaleReplicaSet