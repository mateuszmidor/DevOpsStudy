#!/usr/bin/env bash

trap deleteDeployment SIGINT


function buildDockerImages() {
    eval $(minikube docker-env) # make sure the resulting images will be visible from kubernetes. NOTE: this means not visible from host
    for dir in pngconverter digitchecker webapp; do
        pushd $dir
            ./build_docker_image.sh
        popd
    done
}

function runMinikube() {
    echo "Running minikube"
    minikube start #--vm-driver=none
}

function createDeployment() {
    kubectl create -f kubernetes/checker-deployment.yml
    kubectl create -f kubernetes/checker-service.yml
    kubectl create -f kubernetes/webapp-deployment.yml 
    kubectl create -f kubernetes/webapp-service.yml
}

function deleteDeployment() {
    kubectl delete deployment webapp-deployment 
    kubectl delete service webapp-service
    kubectl delete deployment checker-deployment
    kubectl delete service checker-service
    exit 0
}

function showWebPage() {
    ip=`minikube ip`

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET --max-time 1 $ip:31000/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing DigitRecon Web App. If first time run, wait 60sec until neural network learns the digits :)"
    firefox $ip:31000
    while true; do sleep 1; done
}

buildDockerImages
[[ `minikube status | grep Running` == "" ]] && runMinikube
[[ `minikube status | grep Running` != "" ]] && createDeployment
[[ `kubectl get deployment | grep webapp-deployment` != "" ]] && showWebPage