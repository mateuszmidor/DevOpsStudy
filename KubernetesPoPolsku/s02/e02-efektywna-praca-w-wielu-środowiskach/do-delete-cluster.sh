#!/usr/bin/env bash

CLUSTER_NAME="kubernetes-po-polsku"

function deleteDashboard() {
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
}

function deleteIngress() {
    helm delete -n ingress nginx-ingress
    kubectl delete ns ingress
}

function resetKubectlContext() {
  # this automatically resets current kubectl context
  doctl k8s cluster kubeconfig remove $CLUSTER_NAME
}

function deleteCluster() {
  doctl k8s cluster delete $CLUSTER_NAME
}



deleteIngress
deleteDashboard
resetKubectlContext
deleteCluster