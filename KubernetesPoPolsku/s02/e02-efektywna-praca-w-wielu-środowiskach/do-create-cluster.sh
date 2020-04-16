#!/usr/bin/env bash

CLUSTER_NAME="kubernetes-po-polsku"

function createCluster() {
  doctl k8s cluster create \
    --region fra1 \
    --version latest \
    --tag demo \
    --size s-1vcpu-2gb \
    --count 3 \
    --maintenance-window="tuesday=20:00" \
    --auto-upgrade \
    $CLUSTER_NAME
}

function setupKubectlContext() {
  # this automatically sets kubectl current context to newly created DigitalOcean cluster
  doctl k8s cluster kubeconfig save $CLUSTER_NAME
}

function createDashboard() {
cat << EOF | kubectl apply -f-
apiVersion: v1
kind: ServiceAccount
metadata:
  name: digitalocean-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: digitalocean-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: digitalocean-admin
  namespace: kube-system
EOF

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
}

function createIngress() {
    kubectl create ns ingress
    helm repo add stable https://kubernetes-charts.storage.googleapis.com
    helm install nginx-ingress stable/nginx-ingress  -n ingress  --set controller.publishService.enabled=true
}

createCluster
setupKubectlContext
createDashboard
createIngress