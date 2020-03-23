#!/usr/bin/env bash

trap tearDown SIGINT

CHARTMUSEUM_NAME="mychartmuseum"
LOCALREPO_NAME="minikube"
LOCALREPO_URL="http://charts.127.0.0.1.nip.io" # configured in chart-museum-values.yaml

function waitUrlAvailable() {
    url="$1"
    while [[ `curl -s -o /dev/null -w "%{http_code}" $url` != "200" ]]; do
        echo "Waiting for $url ..."
        sleep 3
    done
}

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

function installChartMuseum() {
    echo
    echo "Installing chart museum and helm push plugin"

    sudo helm repo add stable https://kubernetes-charts.storage.googleapis.com
    sudo helm repo update
    sudo helm install $CHARTMUSEUM_NAME stable/chartmuseum --version 2.9.0 -f chart-museum-values.yaml
    sudo helm plugin install https://github.com/chartmuseum/helm-push.git

    waitUrlAvailable $LOCALREPO_URL
    sudo helm repo add $LOCALREPO_NAME $LOCALREPO_URL
}

function publishMyChart() {
    echo
    echo "Publishing mychart into local chart repo called minikube"

    sudo helm push mychart/ $LOCALREPO_NAME 
    sudo helm repo update
}

function searchPublishedChart() {
    echo
    echo "Searching mychart"
    sudo helm search repo mychart
}

function showWebPage() {
    echo
    echo "Running mychart web page"
    
    sleep 10
    firefox $LOCALREPO_URL
}

function keepAlive() {
    while true; do sleep 1; done
}

function tearDown() {
    sudo helm delete $CHARTMUSEUM_NAME
    exit 0
}

checkPrerequsites
runMinikube

installChartMuseum
publishMyChart
searchPublishedChart
showWebPage
keepAlive