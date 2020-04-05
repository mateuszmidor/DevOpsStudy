#!/usr/bin/env bash

trap tearDown SIGINT

CONTAINER_NAME=""
USER="ansible-user"
PORT="2222"

function stage() {
    COLOR="\e[95m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$COLOR$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    [[ -z $CONTAINER_NAME ]] && echo "You need to provide container name, like linux1" && exit 1

    [[ ! -f $HOME/.ssh/id_rsa.pub ]] && echo "You need to first generate ssh keys under $HOME/.ssh/id_rsa.pub" && exit 1

    command docker --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install docker to run this example" && exit 1

    echo "OK"
}

function runContainer() {
    stage "Running container $CONTAINER_NAME as daemon"
 
    docker run \
        --name $CONTAINER_NAME \
        --rm -d \
        --hostname=$CONTAINER_NAME \
        -e USER_NAME=$USER \
        -e SUDO_ACCESS=true \
        -e PUBLIC_KEY="`cat $HOME/.ssh/id_rsa.pub`" \
        linuxserver/openssh-server
}

function sshIntoContainer() {
    stage "SSH into container $CONTAINER_NAME"
    
    IP=`docker inspect -f {{.NetworkSettings.IPAddress}} $CONTAINER_NAME`
    echo "ssh $USER@$IP -p $PORT"

    sleep 3 # let ssh server time to get up

    while true; do
        ssh $USER@$IP -p $PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
        [[ $? == 0 ]] && break
        sleep 3
    done;
}

function tearDown() {
    stage "Destroying container $CONTAINER_NAME"

    docker kill $CONTAINER_NAME
    exit 0
}

CONTAINER_NAME="$1"

checkPrerequsites
runContainer
sshIntoContainer
tearDown