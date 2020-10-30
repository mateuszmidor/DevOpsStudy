#!/usr/bin/env bash

trap tearDown SIGINT


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

    echo "Done"
}

function createKubernetesObjects() {
    stage "Creating kubernetes objects"

    kubectl apply -f objects.yml

    echo "Done"
}

function showWebPage() {
    stage "Showing web page"

    url=""
    while true; do 
        url=`kubectl get svc hello-world-service -o jsonpath='{ .status.loadBalancer.ingress[0].hostname }'`
        [[ ! -z "$url" ]] && break
        echo "waiting external IP..."
        sleep 3
    done 

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

    kubectl delete -f objects.yml

    echo "Done"
    exit 0
}


checkPrerequsites
createKubernetesObjects
showWebPage
keepAlive