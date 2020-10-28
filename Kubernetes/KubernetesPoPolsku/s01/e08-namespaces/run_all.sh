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


function createNamespaces() {
    stage "Creating namespaces: test, prod"

    kubectl create namespace test
    kubectl create namespace prod
    kubectl get namespace

    echo "Done"
}

function runPods() {
    stage "Running PODs"

    echo "in test namespace"
    kubectl apply --namespace test -f deployment_test.yml

    echo
    echo "in prod namespace"
    kubectl apply --namespace prod -f deployment_prod.yml

    echo "Done"
}

function playWithNamespaces() {
    stage "Checking namespaces"
    
    if [[ ! -d kubectx ]]; then
        echo "Downloading kubens..."
        git clone https://github.com/ahmetb/kubectx.git
        echo "Done"
    fi
    
    echo "See pods in test namespace:"
    kubectx/kubens test
    kubectl get pods

    echo
    echo "See pods in prod namespace:"
    kubectx/kubens prod
    kubectl get pods

    echo
    echo "Going back to defaul namespace"
    kubectx/kubens default 

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"
    
    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    kubectl delete namespace test
    kubectl delete namespace prod
    
    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
createNamespaces
runPods
playWithNamespaces
keepAlive