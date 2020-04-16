#!/usr/bin/env bash

trap tearDown SIGINT


function stage() {
    GREEN="\e[92m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$GREEN$msg$RESET"
}

function getLoadBalancerIP() {
    url=""
    while true; do
        url=`kubectl get svc | grep LoadBalancer | sed 's|\s\s*| |g' | cut -d ' ' -f4`
        [[ $url != "" && $url != "<pending>" ]] && break
        sleep 3
    done
    echo $url
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

    echo "OK"
}

function createKubernetesObjects() {
    stage "Creating kubernetes objects"

    kubectl apply -f objects.yml
}

function showWebPage() {
    stage "Showing web page"

    echo "getting LoadBalancer IP"
    ip=`getLoadBalancerIP`

    echo "waiting for $ip"
    waitHttp200 $ip
    firefox $ip
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    kubectl delete -f objects.yml
    exit 0
}


checkPrerequsites
createKubernetesObjects
showWebPage
keepAlive