#!/usr/bin/env bash

trap tearDown SIGINT

CHARTMUSEUM_NAME="mychartmuseum"

function stage() {
    BOLD_BLUE="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_BLUE$msg$RESET"
}

function waitUrlAvailable() {
    url="$1"
    while [[ `curl -s -o /dev/null -w "%{http_code}" $url` != "200" ]]; do
        echo "Waiting for $url ..."
        sleep 3
    done
}

function getChartMuseumURL() {
    echo "http://charts.`minikube ip`.nip.io"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this lesson" && exit 1

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

function installChartMuseum() {
    stage "Installing chart museum and helm push plugin"

    helm repo add stable https://kubernetes-charts.storage.googleapis.com
    helm repo update

    host=`getChartMuseumURL`
    # --set overrides some configuration from chart-museum-values.yaml
    helm install $CHARTMUSEUM_NAME stable/chartmuseum --version 2.9.0 -f chart-museum-values.yaml --set ingress.hosts[0].host=$host --set ingress.hosts[0].paths[0]="/"
    helm plugin install https://github.com/chartmuseum/helm-push.git

    url=`getChartMuseumURL`
    waitUrlAvailable $url
    helm repo add $CHARTMUSEUM_NAME $url

    echo "Done"
}

function publishMyChart() {
    stage "Publishing mychart into local chart repo called $CHARTMUSEUM_NAME"

    helm push mychart/ $CHARTMUSEUM_NAME 
    helm repo update

    echo "Done"
}

function searchPublishedChart() {
    stage "Searching mychart"

    helm search repo mychart

    echo "Done"
}

function showWebPage() {
    stage "Running chartmuseum web page"
    
    sleep 10
    url=`getChartMuseumURL`
    firefox $url

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    helm delete $CHARTMUSEUM_NAME
    
    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube

installChartMuseum
publishMyChart
searchPublishedChart
showWebPage
keepAlive