#!/usr/bin/env bash

trap tearDown SIGINT

CHART_NAME="mychart"

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

function createMyChart() {
    stage "Creating mychart"
   
    # helm create $CHART_NAME  # already created and extended "mychart/" for example purpose
    echo "Done"
}

function lintMyChart() {
    stage "Linting mychart"
    
    helm lint $CHART_NAME

    echo "Done"
}

function dryRunInstallMyChart() {
    stage "Trying installing mychart"

    helm install --dry-run --debug $CHART_NAME $CHART_NAME/

    echo "Done"
}

function packageMyChart() {
    stage "Packaging mychart"

    helm package $CHART_NAME/  # result: mychart-0.1.0.tgz. Version comes from Chary.yaml: version

    echo "Done"
}

function getServiceURL() {
    echo "mychart.`minikube ip`.nip.io"
}

function installPackagedMyChart() {
    stage "Installing mychart"

    host=`getServiceURL`
    # --set overrides some configuration from values.yaml
    helm install --set ingress.hosts[0].host=$host --set ingress.hosts[0].paths[0]="/" $CHART_NAME mychart-0.1.0.tgz
    # non-packaged would simply install from directory: helm install $CHART_NAME $CHART_NAME/

    echo "Done"
}

function waitServiceReady() {
    stage "Waiting service is up"

    url=`getServiceURL`
    while [[ `curl -X GET --max-time 1 -s -o /dev/null -w "%{http_code}" $url` != "200" ]]; do
        echo "waiting..."
        sleep 3
    done

    echo "Done"
}

function testMyChart() {
    stage "Testing mychart installation"

    #sleep 5 # give the server 5 sec to get up
    helm test $CHART_NAME

    echo "Done"
}

function showWebPage() {
    stage "Running mychart web page"
    
    url=`getServiceURL`
    firefox $url

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    helm delete $CHART_NAME

    echo "Done"
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