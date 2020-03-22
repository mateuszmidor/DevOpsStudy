#!/usr/bin/env bash

trap tearDown SIGINT

CHART_NAME="mychart"

function checkPrerequsites() {
    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this lesson" && exit 1
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

function createMyChart() {
    echo
    echo "Creating mychart"
   
    # helm create $CHART_NAME  # already created and extended "mychart/" for example purpose
}

function lintMyChart() {
    echo
    echo "Linting mychart"
    
    helm lint $CHART_NAME
}

function dryRunInstallMyChart() {
    echo
    echo "Trying installing mychart"

    sudo helm install --dry-run --debug $CHART_NAME $CHART_NAME/
}

function packageMyChart() {
    echo
    echo "Packaging mychart"

    helm package $CHART_NAME/  # result: mychart-0.1.0.tgz. Version comes from Chary.yaml: version
}

function installPackagedMyChart() {
    echo
    echo "Installing mychart"

    sudo helm install $CHART_NAME mychart-0.1.0.tgz
    # non-packaged would simply install from directory: sudo helm install $CHART_NAME $CHART_NAME/
}

function waitServiceReady() {
    echo
    echo "Waiting service is up"

    # wait until
    while true; do
        url=`sudo kubectl describe service $CHART_NAME | sed -n '/Endpoints/ s|.* || p'`
        [[ $url != "" && $url != "<none>" ]] && break
        echo "waiting..."
        sleep 3
    done
}

function testMyChart() {
    echo
    echo "Testing mychart installation"

    #sleep 5 # give the server 5 sec to get up
    sudo helm test $CHART_NAME
}

function showWebPage() {
    echo
    echo "Running mychart web page"
    
    url="mychart.127.0.0.1.nip.io" # ingress, configured in values.yaml
    while [[ `curl -s -o /dev/null -w "%{http_code}" $url` != "200" ]]; do
        echo "Waiting for mychart web page..."
        sleep 3
    done
    
    echo "mychart URL: $url"
    firefox $url
}

function keepAlive() {
    while true; do sleep 1; done
}

function tearDown() {
    sudo helm delete $CHART_NAME
    exit 0
}

checkPrerequsites
runMinikube

createMyChart 
lintMyChart
#dryRunInstallMyChart # disabled because generates lots of text
packageMyChart
installPackagedMyChart
waitServiceReady
testMyChart
showWebPage
keepAlive