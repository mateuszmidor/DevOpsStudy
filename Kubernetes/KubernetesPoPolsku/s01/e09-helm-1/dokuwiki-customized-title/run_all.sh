#!/usr/bin/env bash

trap tearDown SIGINT

RELEASE_NAME="my-dokuwiki"

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

function runHelmDokuWiki() {
    stage "Running dokuwiki helm release "

    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install $RELEASE_NAME bitnami/dokuwiki -f values.yml

    echo "Done"
}

function showWebPage() {
    stage "Running dokuwiki web page"
    
    url=""
    while true; do
        url=`kubectl get svc $RELEASE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
        curl -X GET --max-time 1 $url > /dev/null 2>&1
        [[ $? == 0 ]] && break
        echo "Waiting for dokuwiki server. Make sure to issue 'minikube tunnel', so loadbalancer gets external IP"
        sleep 3
    done
    
    echo "Your dokuwiki URL: $url"
    firefox $url

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    helm delete $RELEASE_NAME
    
    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
runHelmDokuWiki
showWebPage
keepAlive