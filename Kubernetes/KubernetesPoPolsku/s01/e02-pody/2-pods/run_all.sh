#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="producer-consumer"

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

    desired_status=": Control Plane : Running : Running : Running : Configured "
    if [[ `minikube status | egrep -o ":.*" | tr '\n' ' '` != $desired_status ]]; then
        minikube stop
        minikube start
        [[ $? != 0 ]] && echo "Running minikube failed" && exit 1
    fi

    echo "Done"
}

function runPod() {
    stage "Running POD"

    kubectl apply -f deployment.yml

    # wait POD is up
    while [[ `kubectl get pod | grep $POD_NAME | grep Running` == "" ]]; do sleep 1; done

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    # read logs
    kubectl logs producer-consumer -c consumer -f
}

function tearDown() {
    stage "Tear down"

    kubectl delete pod $POD_NAME

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
runPod
keepAlive