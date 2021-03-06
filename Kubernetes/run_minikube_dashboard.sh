#!/usr/bin/env bash


function checkMinikube() {
    command minikube > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "Minikube not installed"
        exit 1
    fi
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

function showDashboard() {
    echo "Running minikube dashboard"
    sudo minikube dashboard &
    
    url=""
    while true; do
        url=`sudo kubectl describe service kubernetes-dashboard --namespace kubernetes-dashboard | sed -n '/Endpoints/ s|.* || p'`
        curl -s > /dev/null 2>&1 $url
        [[ $? == 0 ]] && break
        echo "Waiting for minikube dashboard..."
        sleep 3
    done

    echo "Your Dashboard URL: $url"
    firefox $url
}

checkMinikube
runMinikube
showDashboard
