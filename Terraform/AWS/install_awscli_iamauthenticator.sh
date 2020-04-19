#!/usr/bin/env bash

function stage() {
    GREEN="\e[92m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$GREEN$msg$RESET"
}

function installAwsCli() {
    stage "Installing AWS CLI"

    command aws --version > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        pip install awscli --upgrade --user
    else
        echo "aws cli already installed"
    fi
}

function installAwsIamAuthenticator() {
    stage "Installing AWS IAM Authenticator"

    command aws-iam-authenticator version > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        pamac build aws-iam-authenticator-bin
    else
        echo "aws-iam-authenticator already installed"
    fi
}

function configureAwsCli() {
    stage "Configuring AWS CLI"

    echo "find the secret keys here: https://console.aws.amazon.com/iam/home?region=eu-central-1#/security_credentials"
    aws configure
}


installAwsCli
configureAwsCli
installAwsIamAuthenticator