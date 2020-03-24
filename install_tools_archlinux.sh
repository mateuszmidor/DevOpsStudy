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

function installHelmArchLinux() {
    command helm > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "Installing helm"
        pamac build kubernetes-helm
        [[ $? != 0 ]] && echo "Installing helm failed" && exit 1
    else
        echo "Helm is installed"
    fi
}

function installKubeCTX {
    command sudo kubectx > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "Installing kubectx"
        pamac build kubectx-git
        [[ $? != 0 ]] && echo "Installing kubectx failed" && exit 1
    else
        echo "kubectx is installed"
    fi
}

installMinikubeArchLinux
installHelmArchLinux
installKubeCTX