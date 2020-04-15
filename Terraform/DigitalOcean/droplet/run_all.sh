#!/usr/bin/env bash

trap tearDown SIGINT


function stage() {
    COLOR="\e[96m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    [[ -z $DO_TOKEN ]] && echo "You need to export variable DO_TOKEN first" && exit 1

    [[ -z $DO_FINGERPRINT ]] && echo "You need to export variable DO_FINGERPRINT first" && exit 1

    command terraform version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install terraform to run this example" && exit 1

    echo "OK"
}

function createResources() {
    stage "Creating droplet resources"

    terraform init
    terraform apply \
        -auto-approve \
        -var "ssh_fingerprint=$DO_FINGERPRINT" \
        -var "do_token=$DO_TOKEN"
}

function sshIntoInstance() {
    stage "Logging SSH into instance"

    IP=`python get_ipv4.py`
    while true; do
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$IP
        [[ $? == 0 ]] && break
        sleep 3
    done;
}

function tearDown() {
    stage "Destroying droplet resources"

    terraform destroy \
        -auto-approve \
        -var "ssh_fingerprint=$DO_FINGERPRINT" \
        -var "do_token=$DO_TOKEN"
    exit 0
}


checkPrerequsites
createResources
sshIntoInstance
tearDown