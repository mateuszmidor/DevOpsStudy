#!/usr/bin/env bash

trap tearDown SIGINT

RELEASE_NAME="my-dokuwiki"

function stage() {
    GREEN="\e[92m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$GREEN$msg$RESET"
}

function waitHttp200() {
    url=$1
    while true; do
        http_code=`curl -s -o /dev/null -w "%{http_code}" $url`
        [[ $http_code -ge 200 ]] && [[ $http_code -lt 400 ]] && break
        echo "waiting..."
        sleep 3
    done
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command kubectl help > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install kubectl to run this example" && exit 1

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this example" && exit 1

    echo "OK"
}

function makeDns() {
    # make nip.io DNS from loadbalancer ip
    ip=""
    while [[ $ip == "" ]]; do
        ip=$(kubectl get svc nginx-ingress-controller -o jsonpath="{ .status['loadBalancer']['ingress'][0]['ip'] }" -n ingress)
        [[ $ip != "" ]] && break
        echo "waiting for external IP..."
        sleep 3
    done;
    dns="mywiki.$ip.nip.io"
    export DNS="$dns"
}

function runHelmDokuWiki() {
    stage "Running dokuwiki helm release"

    makeDns
    helm repo add bitnami https://charts.bitnami.com/bitnami
    echo "Installing dokuwiki with ingress set to $DNS"
    helm install $RELEASE_NAME bitnami/dokuwiki -f values.yml --set ingress.hosts[0].name=$DNS
}

function showWebPage() {
    stage "Running dokuwiki web page"
    
    url=$DNS
    echo "Waiting for $url"
    waitHttp200 $url
    firefox $url
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    helm delete $RELEASE_NAME
    exit 0
}

checkPrerequsites
runHelmDokuWiki
showWebPage
keepAlive