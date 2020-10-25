#!/usr/bin/env bash

trap tearDown SIGINT

CHARTMUSEUM_NAME="mychartmuseum"
CHARTMUSEUM_URL="http://charts.127.0.0.1.nip.io" # configured in chart-museum-values.yaml

function stage() {
    GREEN="\e[92m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$GREEN$msg$RESET"
}

function waitUrlAvailable() {
    url="$1"
    while [[ `curl -s -o /dev/null -w "%{http_code}" $url` != "200" ]]; do
        echo "Waiting for $url ..."
        sleep 3
    done
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this lesson" && exit 1

    echo "OK"
}

function runMinikube() {
    stage "Running Minikube"

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
    stage "Installing chart museum and helm push plugin"

    sudo helm repo add stable https://kubernetes-charts.storage.googleapis.com
    sudo helm repo update
    sudo helm install $CHARTMUSEUM_NAME stable/chartmuseum --version 2.9.0 -f chart-museum-values.yaml
    sudo helm plugin install https://github.com/chartmuseum/helm-push.git

    waitUrlAvailable $CHARTMUSEUM_URL
    sudo helm repo add $CHARTMUSEUM_NAME $CHARTMUSEUM_URL
}

function publishMyChart() {
    stage "Publishing mychart into local chart repo called $CHARTMUSEUM_NAME"

    sudo helm push mychart/ $CHARTMUSEUM_NAME 
    sudo helm repo update
}

function searchPublishedChart() {
    stage "Searching mychart"

    sudo helm search repo mychart
}

function showWebPage() {
    stage "Running chartmuseum web page"
    
    sleep 10
    firefox $CHARTMUSEUM_URL
    echo "OK"
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