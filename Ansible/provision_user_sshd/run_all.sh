#!/usr/bin/env bash

trap tearDown SIGINT

HOST1="linux1"
USER="user"
SSH_PORT=22

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

function runContainers() {
    stage "Running container $HOST1 as daemon"
 
    docker run \
        --name $HOST1 \
        --hostname $HOST1 \
        --rm -d \
        alpine \
        sleep 3600
}

function runAnsible() {
    stage "Running ansible"

    ansible-playbook --extra-vars "USER=$USER" playbook.yml
}

function sshIntoContainer1() {
    stage "SSH into container $HOST1"

    # wait ssh ready
    IP=`docker inspect -f {{.NetworkSettings.IPAddress}} $HOST1`
    while true; do
        ssh $USER@$IP -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null whoami
        [[ $? == 0 ]] && break
        sleep 3
    done;

    ssh $USER@$IP -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
}

function tearDown() {
    stage "Destroying containers"

    docker kill $HOST1
    exit 0
}

checkPrerequsites
runContainers
runAnsible
sshIntoContainer1
tearDown