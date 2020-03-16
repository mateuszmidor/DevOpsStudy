#!/usr/bin/env bash


function installMinikubeArchLinux() {
    command minikube > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "Installing minikube"
        pamac build minikube-bin
        [[ $? != 0 ]] && echo "Installing minikube failed" && exit 1
    else
        echo "Minikube is installed"
    fi
}


installMinikubeArchLinux
