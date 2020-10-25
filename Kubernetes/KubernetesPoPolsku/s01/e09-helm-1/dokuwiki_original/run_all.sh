#!/usr/bin/env bash

trap tearDown SIGINT

RELEASE_NAME="my-dokuwiki"

function checkPrerequsites() {
    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this lesson" && exit 1
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

function runHelmDokuWiki() {
    echo
    echo "Running dokuwiki helm release "
    sudo helm repo add bitnami https://charts.bitnami.com/bitnami
    sudo helm install $RELEASE_NAME bitnami/dokuwiki 
}

function showWebPage() {
    echo
    echo "Running dokuwiki web page"
    
    url=""
    while true; do
        url=`sudo kubectl describe service $RELEASE_NAME | sed -n '/IP/ s|.* || p'`
        curl -s > /dev/null 2>&1 $url
        [[ $? == 0 ]] && break
        echo "Waiting for dokuwiki server..."
        sleep 3
    done
    
    echo "Your dokuwiki URL: $url"
    firefox $url
}

function keepAlive() {
    while true; do sleep 1; done
}

function tearDown() {
    sudo helm delete $RELEASE_NAME
    exit 0
}

checkPrerequsites
runMinikube
runHelmDokuWiki
showWebPage
keepAlive