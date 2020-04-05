#!/usr/bin/env bash

trap tearDown SIGINT

HOST1="linux1"
HOST2="linux2"
SSH_PORT=2222
USER="ansible-user"

function stage() {
    COLOR="\e[95m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    [[ ! -f $HOME/.ssh/id_rsa.pub ]] && echo "You need to first generate ssh keys under $HOME/.ssh/id_rsa.pub" && exit 1

    command docker --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install docker to run this example" && exit 1

    command ansible --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install ansible to run this example" && exit 1

    echo "OK"
}

function runAnsible() {
    stage "Running ansible"

    IP1="172.17.0.8"
    IP2="172.17.0.9"

    ansible-playbook \
        -i inventory.yaml dump_all_variables.yaml \
        --extra-vars "HOST1_IP=$IP1 HOST2_IP=$IP2 USER=$USER PORT=$SSH_PORT"
}

function printDumpedVariables() { 
    stage "Dumping ansible host variables"

    cat dumped_vars.j2
}

function tearDown() {
    exit 0
}


checkPrerequsites
runAnsible
printDumpedVariables