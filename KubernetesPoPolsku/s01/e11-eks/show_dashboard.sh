#!/usr/bin/env bash

trap tearDown SIGINT

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

function runDashboard() {
    stage "Your dashboard token"

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
}

function showDashboard() {
    stage "Showing dashboard"

    URL="http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login"
    kubectl proxy &
    waitHttp200 $URL
    firefox $URL
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    pkill -f "kubectl proxy"
    exit 0
}

runDashboard
showDashboard
keepAlive