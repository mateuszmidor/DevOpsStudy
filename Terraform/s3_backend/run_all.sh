#!/usr/bin/env bash

trap tearDown SIGINT

BUCKET_NAME="terraform-study-s3-bucket"
REGION="eu-central-1"

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
    [[ $? != 0 ]] && echo "You need to install and configure aws cli to run this example" && exit 1

    command terraform version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install terraform to run this example" && exit 1

    echo "OK"
}

function createS3Bucket() {
    stage "Creating S3 Bucket for storing terraform state"

    aws s3 mb s3://$BUCKET_NAME --region $REGION

    echo "waiting for the bucket to come online"
    aws s3api wait bucket-exists --bucket $BUCKET_NAME
}

function createResources() {
    stage "Creating EC2 resources"

    terraform init
    terraform apply -auto-approve
}

function printDNS() {
    stage "Instance created:"

    # terraform state is stored in S3 bucket in this example so need to download it first
    STATE_FILE="terraform.tfstate"
    aws s3 cp s3://$BUCKET_NAME/$STATE_FILE . > /dev/null
    python get_dns.py
    rm $STATE_FILE
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Destroying EC2 resources and S3 bucket"

    terraform destroy -auto-approve
    aws s3 rb s3://$BUCKET_NAME --force # --force removes contents first
    rm -rf .terraform
    exit 0
}


checkPrerequsites
createS3Bucket
createResources
printDNS
keepAlive