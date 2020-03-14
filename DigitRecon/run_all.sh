#!/usr/bin/env bash

trap deleteDeployment SIGINT


function buildDockerImages() {
  for dir in pngconverter digitchecker webapp; do
    pushd $dir
      ./build_docker_image.sh
    popd
  done
}

function runMinikube() {
    echo "Running minikube"
    sudo rm /tmp/juju-mk*
    sudo minikube start --vm-driver=none
}

function createDeployment() {
  sudo kubectl create -f kubernetes/checker-deployment.yml
  sudo kubectl create -f kubernetes/checker-service.yml
  sudo kubectl create -f kubernetes/webapp-deployment.yml 
  sudo kubectl create -f kubernetes/webapp-service.yml
}

function deleteDeployment() {
    sudo kubectl delete deployment webapp-deployment 
    sudo kubectl delete service webapp-service
    sudo kubectl delete deployment checker-deployment
    sudo kubectl delete service checker-service
    exit 0
}

function showWebPage() {
    ip=`sudo minikube ip`

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl -X GET --max-time 1 $ip:31000/ > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    echo "Showing DigitRecon Web App. If first time run, wait 60sec until neural network learns the digits :)"
    firefox $ip:31000
    while true; do sleep 1; done
}

buildDockerImages
[[ `sudo minikube status | grep Running` == "" ]] && runMinikube
[[ `sudo minikube status | grep Running` != "" ]] && createDeployment
[[ `sudo kubectl get deployment | grep webapp-deployment` != "" ]] && showWebPage