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

    command kubectl options > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install kubectl to run this example" && exit 1

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this example" && exit 1

    echo "Done"
}

function makeDns() {
    # make nip.io DNS from loadbalancer ip
    elb=""
    while [[ $elb == "" ]]; do
        elb=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath="{ .status['loadBalancer']['ingress'][0]['hostname'] }")
        [[ $elb != "" ]] && break
        echo "waiting for external IP..."
        sleep 3
    done;

    ip=`getent hosts $elb | head -n 1 | cut -d ' ' -f1` # first loadbalancer IP
    dns="mywiki.$ip.nip.io"
    export DNS="$dns"
}

function runHelmDokuWiki() {
    stage "Running dokuwiki helm release"

    makeDns
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install $RELEASE_NAME bitnami/dokuwiki -f values.yml --set ingress.hosts[0].name=$DNS

    echo "Done"
}

function showWebPage() {
    stage "Running dokuwiki web page"
    
    url=$DNS
    while true; do
        http_code=`curl -s -o /dev/null -w "%{http_code}" $url`
        [[ $http_code -ge 200 ]] && [[ $http_code -lt 400 ]] && break
        echo "waiting server ready..."
        sleep 3
    done
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
runHelmDokuWiki
showWebPage
keepAlive