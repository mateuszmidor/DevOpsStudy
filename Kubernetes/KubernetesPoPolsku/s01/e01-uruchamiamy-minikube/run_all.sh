#!/usr/bin/env bash

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

    echo "Done"
}

function runMinikube() {
    stage "Running minikube"

    desired_status=": Control Plane : Running : Running : Running : Configured "
    if [[ `minikube status | egrep -o ":.*" | tr '\n' ' '` != $desired_status ]]; then
        minikube stop
        minikube start
        [[ $? != 0 ]] && echo "Running minikube failed" && exit 1
    fi

    echo "Done"
}

function showDashboard() {
    stage "Running minikube dashboard"
    
    minikube dashboard &
    
    url=""
    while true; do
        url=`kubectl describe service kubernetes-dashboard --namespace kubernetes-dashboard | sed -n '/Endpoints/ s|.* || p'`
        curl -s > /dev/null 2>&1 $url
        [[ $? == 0 ]] && break
        echo "Waiting for minikube dashboard..."
        sleep 3
    done
    echo "Your Dashboard URL: $url"
    firefox $url

    echo "Done"
}

checkPrerequsites
runMinikube
showDashboard