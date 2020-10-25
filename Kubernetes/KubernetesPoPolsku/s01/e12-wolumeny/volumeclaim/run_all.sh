#!/usr/bin/env bash

trap tearDown SIGINT

NS_NAME="kubernetes-po-polsku-s01e12"
POD_NAME="volumeclaim-pod"

function stage() {
    GREEN="\e[92m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$GREEN$msg$RESET"
}

function waitPodStatus() {
    pod_name="$1"
    pod_status="$2"
    stage "Waiting $pod_name is $pod_status"

    while [[ `sudo kubectl get pod | grep $pod_name | grep $pod_status` == "" ]]; do sleep 1; done
    echo "OK"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    command sudo kubens > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install kubens" && exit 1

    echo "OK"
}

function runMinikube() {
    stage "Running Minikube"

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

function switchNamespace() {
    stage "Switching to namespace $NS_NAME"

    sudo kubectl create namespace $NS_NAME
    sudo kubens $NS_NAME
}

function runExample() {
    stage "Runnig pod"

    sudo kubectl apply -f objects.yml
    waitPodStatus $POD_NAME "Completed"
}

function showLogs() {
    stage "Printing pod logs"
    
    sudo kubectl logs $POD_NAME -f
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    sudo kubens default
    sudo kubectl delete namespace $NS_NAME

    # persistentvolumes live outside namespaces
    sudo kubectl delete persistentvolume hostvol1
    sudo kubectl delete persistentvolume hostvol2

    echo "Done."
    exit 0
}

checkPrerequsites
runMinikube

switchNamespace
runExample
showLogs
keepAlive