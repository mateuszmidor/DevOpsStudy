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

function createCluster() {
    stage "Creating cluster" 
    # cluster name: TestCluster
    # node type: t2.small (2GB, 1vCPU); smallest instance that can run all the PODs we need
    # node count: 3
    # logging: level 4
    eksctl create cluster -n TestCluster -t t2.small -N 3 -v4

    echo "Done"
}

function createDashboard() {
    stage "Creating dashboard"

    # source: https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

    echo "Done"
}

function createHeapster() {
    stage "Creating heapster"

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

    echo "Done"
}

function createServiceAccount() {
    stage "Creating service account"

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

    echo "Done"
}

function createStorageClass() {
    stage "Creating storage class"

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

    echo "Done"
}

function createIngress() {
    stage "Creating ingress"
    
    kubectl create ns ingress-nginx
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/cloud/deploy.yaml

    echo "Done"
}

checkPrerequsites
createCluster
createDashboard
createHeapster
createServiceAccount
createStorageClass
createIngress