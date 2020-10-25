#!/usr/bin/env bash

trap tearDown SIGINT

REPLICASET_NAME="hello-world-replicaset"
SERVICE_NAME="hello-world-service"
INGRESS_NAME="hello-world-ingress"

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

function configIngress() {
    if [[ `sudo minikube addons list | grep ingress | grep enabled` == "" ]]; then
        echo "Minikube ingress is not running. Run now..."
        sudo minikube addons enable ingress
        echo "Done."
    else
        echo "Minikube ingress is running"
    fi
}

function runAll() {
    echo "Running ReplicaSet, Service and Ingress"
    sudo kubectl apply -f deployment.yml

    # wait replicaset is up
    while [[ `sudo kubectl get replicaset | grep $REPLICASET_NAME` == "" ]]; do sleep 1; done

    # wait pod is up. Pod name is replicaset name + some id
    while [[ `sudo kubectl get pods | grep $REPLICASET_NAME | grep Running` == "" ]]; do sleep 1; done

    # wait ingress is up
    while [[ `sudo kubectl get ingress | grep $INGRESS_NAME` == "" ]]; do sleep 1; done
}

function showWebPage() {
    url="hello-world.127.0.0.1.nip.io" # defined in deployment.yml

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl --max-time 1 $url > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    # user/pass is configured in deployment.yml
    echo "User/Pass: user/user"
    sleep 3
    firefox $url
    
    while true; do sleep 1; done
}

function tearDown() {
    sudo kubectl delete ingress $INGRESS_NAME
    sudo kubectl delete service $SERVICE_NAME
    sudo kubectl delete replicaset $REPLICASET_NAME
    exit 0
}

checkPrerequsites
runMinikube
configIngress
runAll
showWebPage