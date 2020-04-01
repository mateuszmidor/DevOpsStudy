#!/usr/bin/env bash

function createCluster() {
    # cluster name: TestCluster
    # node type: t2.small (2GB, 1vCPU); smallest instance that can run all the PODs we need
    # node count: 3
    # logging: level 4
    eksctl create cluster -n TestCluster -t t2.small -N 3 -v4
}

function createDashboard() {
    # source: https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
}

function createHeapster() {
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
}

function createServiceAccount() {
cat << EOF | kubectl apply -f-
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system
EOF
}

function createStorageClass() {
cat << EOF | kubectl apply -f-
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  zone: eu-central-1
# only for testing!!
reclaimPolicy: Delete
mountOptions:
  - debug
EOF
    kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
}

function createIngress() {
    kubectl create ns ingress-nginx
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/service-l4.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/aws/patch-configmap-l4.yaml
}


createCluster
createDashboard
createHeapster
createServiceAccount
createStorageClass
createIngress