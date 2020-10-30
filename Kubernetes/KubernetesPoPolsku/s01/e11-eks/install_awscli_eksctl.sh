#!/usr/bin/env bash

function stage() {
    BOLD_BLUE="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_BLUE$msg$RESET"
}

function installAwsCli() {
    stage "Installing AWS CLI"

    command aws --version > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        pip install awscli --upgrade --user
    else
        echo "aws cli already installed"
    fi

    echo "Done"
}

function configureAwsCli() {
    stage "Configuring AWS CLI"

    echo "find the secret keys here: https://console.aws.amazon.com/iam/home?region=eu-central-1#/security_credentials"
    aws configure

    echo "Done"
}

function installEksctl() {
    stage "Installing eksctl"

    command eksctl > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        sudo pacman -S eksctl
    else
        echo "eksctl already installed"
    fi

    echo "Done"
}


installAwsCli
configureAwsCli
installEksctl