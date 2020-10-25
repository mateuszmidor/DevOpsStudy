#!/usr/bin/env bash

function stage() {
    BLUE_BOLD="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BLUE_BOLD$msg$RESET"
}

function installMinikubeArchLinux() {
    stage "Installing minikube"

    command minikube > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        sudo pacman -S minikube
        [[ $? != 0 ]] && echo "Installing minikube failed" && exit 1
    fi
    echo "Minikube is installed"
}

function installHelmArchLinux() {
    stage "Installing helm"

    command helm > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        sudo pacman -S helm
        [[ $? != 0 ]] && echo "Installing helm failed" && exit 1
    fi
    echo "Helm is installed"
}

function installKubectlArchLinux() {
    stage "Installing kubectl"

    command kubectl > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        sudo pacman -S kubectl
        [[ $? != 0 ]] && echo "Installing kubectl failed" && exit 1
    fi
    echo "kubectl is installed"
}

function installK9SArchLinux() {
    stage "Installing k9s"

    command k9s --version > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        sudo pacman -S k9s
        [[ $? != 0 ]] && echo "Installing k9s failed" && exit 1
    fi
    echo "k9s is installed"
}

function installKubeCTX {
    stage "Installing kubectx"

    command kubectx > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        pamac build kubectx-git
        [[ $? != 0 ]] && echo "Installing kubectx failed" && exit 1
    fi
    echo "kubectx is installed"
}

installMinikubeArchLinux
installHelmArchLinux
installKubectlArchLinux
installK9SArchLinux
installKubeCTX