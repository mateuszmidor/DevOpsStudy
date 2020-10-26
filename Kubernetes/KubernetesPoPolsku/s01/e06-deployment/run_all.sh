#!/usr/bin/env bash

trap tearDown SIGINT

DEPLOYMENT_NAME="alpine-linux-deployment"

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

function runDeployment() {
    stage "Creating Deployment"

    kubectl apply -f deployment.yml

    # wait Deployment is up
    while [[ `kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{ .status.readyReplicas }'` != "8" ]]; do 
        echo "waiting..."; 
        sleep 1; 
    done

    echo "Done"
}

function upgradeContainer() {
    stage "Upgrading docker container version"

    echo "Now we upgrade container 3.10 -> 3.11. Watch the rolling update"
    sleep 5
    
    # docker image version is alpine:3.10
    # lets upgrade to apline:3.11
    kubectl set image deploy/alpine-linux-deployment alpine-linux-container=alpine:3.11 --record &

    # show the rolling update progress
    watch -n1 kubectl get replicaset

    echo "Done"
}

function rollbackContainer() {
    stage "Rolling back docker container upgrade"

    # see the available rollback history
    kubectl rollout history deploy/alpine-linux-deployment

    # rollback
    kubectl rollout undo deploy/alpine-linux-deployment

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    echo "Tear down"

    kubectl delete deployment $DEPLOYMENT_NAME

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
runDeployment
upgradeContainer
rollbackContainer
keepAlive