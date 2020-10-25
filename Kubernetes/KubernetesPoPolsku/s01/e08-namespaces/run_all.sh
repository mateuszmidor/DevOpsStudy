#!/usr/bin/env bash

trap tearDown SIGINT

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

function createNamespaces() {
    echo
    echo "Creating namespaces: test, prod"
    sudo kubectl create namespace test
    sudo kubectl create namespace prod
    sudo kubectl get namespace
}

function runPods() {
    echo
    echo "Running POD in test namespace"
    sudo kubectl apply --namespace test -f deployment_test.yml

    echo
    echo "Running POD in prod namespace"
    sudo kubectl apply  --namespace prod -f deployment_prod.yml
}

function playWithNamespaces() {
    echo
    
    if [[ ! -d kubectx ]]; then
        echo "Downloading kubens..."
        git clone https://github.com/ahmetb/kubectx.git
        echo "Done"
    fi
    
    echo "See pods in test namespace:"
    sudo kubectx/kubens test
    sudo kubectl get pods

    echo
    echo "See pods in prod namespace:"
    sudo kubectx/kubens prod
    sudo kubectl get pods

    echo
    echo "Going back to defaul namespace"
    sudo kubectx/kubens default 
}

function keepAlive() {
    while true; do sleep 1; done
}

function tearDown() {
    sudo kubectl delete namespace test
    sudo kubectl delete namespace prod
    exit 0
}

checkPrerequsites
runMinikube
createNamespaces
runPods
playWithNamespaces
keepAlive