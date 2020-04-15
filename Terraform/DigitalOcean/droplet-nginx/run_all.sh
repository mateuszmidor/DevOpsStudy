#!/usr/bin/env bash

trap tearDown SIGINT

PRIV_KEY="$HOME/.ssh/id_rsa"

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

    [[ ! -f "$PRIV_KEY" ]] && echo "You need your private ssh key under $PRIV_KEY" && exit 1

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
        -var "do_token=$DO_TOKEN" \
        -var "pvt_key=$PRIV_KEY"
}

function showWebPage() {
    stage "Showing web page"

    IP=`python get_ipv4.py`
    firefox $IP
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Destroying droplet resources"

    terraform destroy \
        -auto-approve \
        -var "ssh_fingerprint=$DO_FINGERPRINT" \
        -var "do_token=$DO_TOKEN" \
        -var "pvt_key=$PRIV_KEY"
    exit 0
}


checkPrerequsites
createResources
showWebPage
keepAlive
tearDown