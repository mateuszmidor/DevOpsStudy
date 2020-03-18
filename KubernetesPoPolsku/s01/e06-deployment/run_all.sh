#!/usr/bin/env bash

trap tearDown SIGINT

DEPLOYMENT_NAME="alpine-linux-deployment"

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

function runDeployment() {
    echo "Running Deployment"
    sudo kubectl apply -f deployment.yml

    # wait Deployment is up
    while [[ `sudo kubectl get deployment | grep $DEPLOYMENT_NAME | sed 's|\s\s*| |g' | cut -d ' ' -f4` != "8" ]]; do sleep 1; done

    echo "Deployment ready."
}

function upgradeContainer() {
    echo "Now we upgrade container 3.10 -> 3.11. Watch the rolling update"
    sleep 5
    
    # docker image version is alpine:3.10
    # lets upgrade to apline:3.11
    sudo kubectl set image deploy/alpine-linux-deployment alpine-linux-container=alpine:3.11 --record &

    # show the rolling update progress
    watch -n1 sudo kubectl get replicaset
}

function rollbackContainer() {
    # see the available rollback history
    sudo kubectl rollout history deploy/alpine-linux-deployment

    # rollback
    sudo kubectl rollout undo deploy/alpine-linux-deployment
}

function tearDown() {
    sudo kubectl delete deployment $DEPLOYMENT_NAME
    exit 0
}

checkPrerequsites
runMinikube
runDeployment
upgradeContainer