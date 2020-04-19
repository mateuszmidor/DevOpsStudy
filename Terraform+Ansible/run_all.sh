#!/usr/bin/env bash

trap tearDown SIGINT

PEM="$HOME/Downloads/terraform-key.pem"

function stage() {
    COLOR="\e[96m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command aws --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install aws cli to run this example" && exit 1
    
    [[ ! -f "$PEM" ]] && echo "You need keypair file at: $PEM" && exit 1

    command terraform version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install terraform to run this example" && exit 1
    
    command ansible --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install ansible to run this example" && exit 1

    echo "OK"
}

function waitHttp200() {
    url=$1
    while true; do
        http_code=`curl -s -o /dev/null -w "%{http_code}" $url`
        [[ $http_code -ge 200 ]] && [[ $http_code -lt 400 ]] && break
        echo "waiting..."
        sleep 3
    done
}

function createResources() {
    stage "Creating EC2 resources"

    terraform init
    terraform apply -auto-approve
}

function createInventoryFile() {
    stage "Generating ansible inventory file from terraform.tfstate"

    terraform output dns > inventory.ini
}

function configureResources() {
    stage "Configuring instance with ansible"

    ansible-playbook \
        playbook.yml \
        -i inventory.ini \
        -u ubuntu \
        --private-key $PEM \
        --ssh-extra-args "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" #-vvvv
}

function showWebPage() {
    stage "Displaying web page"

    DNS=`terraform output dns`
    waitHttp200 $DNS
    firefox $DNS
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Destroying EC2 resources"

    terraform destroy -auto-approve
    exit 0
}


checkPrerequsites
createResources
createInventoryFile
configureResources
showWebPage
keepAlive