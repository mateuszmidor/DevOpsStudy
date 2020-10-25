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

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

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

function buildDockerImages() {
    stage "Building Docker images"

    eval $(minikube docker-env) # make sure the resulting images will be visible from kubernetes. NOTE: this means not visible from host
    for dir in pngconverter digitchecker webapp; do
        pushd $dir
            ./build_docker_image.sh
            [[ $? != 0 ]] && echo "Building docker image $dir failed" && exit 1
        popd
    done

    echo "Done"
}

function createKubernetesResources() {
    stage "Creating kubernetes resources"

    kubectl create -f kubernetes/checker-deployment.yml && \
    kubectl create -f kubernetes/checker-service.yml && \
    kubectl create -f kubernetes/webapp-deployment.yml && \
    kubectl create -f kubernetes/webapp-service.yml 
    [[ $? != 0 ]] && echo "Creating kubernetes resources failed" && exit 1

    echo "Done"
}

function showWebPage() {
    stage "Showing digit recognizer web page"

    ip=`minikube ip`
    url="$ip:31000"

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET --max-time 1 $url > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing DigitRecon Web App. If first time run, wait 60sec until neural network learns the digits :)"
    firefox $url

    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    kubectl delete deployment webapp-deployment 
    kubectl delete service webapp-service
    kubectl delete deployment checker-deployment
    kubectl delete service checker-service

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
buildDockerImages
createKubernetesResources
showWebPage
keepAlive