#!/usr/bin/env bash

function stage() {
    BOLD_BLUE="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_BLUE$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command eksctl version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install eksctl to run AWS cluster" && exit 1

    command kubectl options > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install kubectl to operate cluster" && exit 1


    echo "Done"
}

function deleteDashboard() {
    stage "Deleting dashboard"

    kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

    echo "Done"
}

function deleteHeapster() {
    stage "Deleting heapster"

    kubectl delete -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

    echo "Done"
}

function deleteIngress() {
    stage "Deleting ingress"

    kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/cloud/deploy.yaml

    echo "Done"
}

function deleteCluster() {
    stage "Deleting cluster"

    eksctl delete cluster TestCluster

    echo "Done"
}

checkPrerequsites
deleteDashboard
deleteHeapster
deleteIngress
deleteCluster