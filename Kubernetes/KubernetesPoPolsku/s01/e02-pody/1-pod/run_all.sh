#!/usr/bin/env bash

trap tearDown SIGINT

POD_NAME="hello-world-pod"

function checkPrerequsites() {
    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    command socat -h > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install socat for port forwarding" && exit 1
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

function runPod() {
    echo "Running POD"
    sudo kubectl apply -f deployment.yml

    # wait POD is up
    while [[ `sudo kubectl get pod | grep $POD_NAME | grep Running` == "" ]]; do sleep 1; done
}

function showWebPage() {
    ip="127.0.0.1"
    port="8000"

    # setup port forwarding from localhost into pod
    sudo kubectl port-forward $POD_NAME $port:80 &

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl --max-time 1 $ip:$port/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    firefox $ip:$port
    
    # read logs
    sudo kubectl logs hello-world-pod -c hello-world-container -f
}

function tearDown() {
    sudo kubectl delete pod $POD_NAME
    exit 0
}

checkPrerequsites
runMinikube
runPod
showWebPage