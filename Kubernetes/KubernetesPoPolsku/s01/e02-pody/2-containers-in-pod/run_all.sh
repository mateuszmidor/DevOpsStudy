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

function runPod() {
    stage "Running POD"

    kubectl apply -f pod.yml

    # wait both POD containers are up
    while [ `kubectl get pod $POD_NAME -o jsonpath='{ .status.containerStatuses[0].ready }'` != "true" ] || 
          [ `kubectl get pod $POD_NAME -o jsonpath='{ .status.containerStatuses[1].ready }'` != "true" ]
    do 
        echo "waiting..."; 
        sleep 1; 
    done

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    # read logs
    kubectl logs $POD_NAME -c consumer -f
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