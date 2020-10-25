#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="hello-world-pod"
CONTAINER_NAME="hello-world-container"

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

function showWebPage() {
    stage "Showing web page serviced by POD"

    ip="127.0.0.1"
    port="8000"

    # setup port forwarding from localhost into pod
    kubectl port-forward $POD_NAME $port:80 &

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl --max-time 1 $ip:$port/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    firefox $ip:$port
    
    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    # read logs
    kubectl logs $POD_NAME -c $CONTAINER_NAME -f
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
showWebPage
keepAlive