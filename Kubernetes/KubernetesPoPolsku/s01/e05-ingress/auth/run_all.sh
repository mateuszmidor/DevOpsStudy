#!/usr/bin/env bash

trap tearDown SIGINT

REPLICASET_NAME="hello-world-replicaset"
SERVICE_NAME="hello-world-service"
INGRESS_NAME="hello-world-ingress"

function stage() {
    BOLD_BLUE="\e[1m\e[34m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_BLUE$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command minikube > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install minicube to run local cluster" && exit 1

    echo "Done"
}

function runMinikube() {
    stage "Running minikube"

    host_status=`minikube status -f '{{ .Host }}'`
    kubelet_status=`minikube status -f '{{ .Kubelet }}'`
    apiserver_status=`minikube status -f '{{ .APIServer }}'`
    if [ $host_status != "Running"  ] || [ $kubelet_status != "Running"  ] || [ $apiserver_status != "Running"  ]; then
        minikube stop
        minikube start
        [[ $? != 0 ]] && echo "Running minikube failed" && exit 1
    fi

    echo "Done"
}

function configIngress() {
    stage "Configuring Ingress minikube addon"

    if [[ `minikube addons list | grep ingress | grep enabled` == "" ]]; then
        echo "Minikube ingress is not running. Run now..."
        minikube addons enable ingress
    fi

    echo "Done"
}

function createReplicaSetServiceIngress() {
    stage "Creating ReplicaSet, Service and Ingress"

    kubectl apply -f replicaset_service_ingress.yml

    # wait ReplicaSet is up
    while [[ `kubectl get replicaset $REPLICASET_NAME -o jsonpath='{ .status.readyReplicas }'` != "3" ]]; do 
        echo "waiting..."; 
        sleep 1; 
    done

    # wait ingress is up
    while [[ `kubectl get ingress $INGRESS_NAME -o jsonpath='{ .kind }'` != "Ingress" ]]; do 
        echo "waiting..."; 
        sleep 1; 
    done

    echo "Done"
}

function patchIngressHost() {
    stage "Patching ingress host to minikube ip"

    # the ingress host IP part must be minikube IP
    host="hello-world.`minikube ip`.nip.io"
    kubectl patch ingress $INGRESS_NAME --type='json' -p='[{"op": "replace", "path": "/spec/rules/0/host", "value":"'$host'"}]'

    echo "Done"
}

function showWebPage() {
    stage "Showing web page"

    url="hello-world.`minikube ip`.nip.io"

    # wait till http server is up
    echo "Waiting for http server to get up"
    while true; do curl --max-time 1 $url > /dev/null 2>&1; [[ $? == 0 ]] && break; sleep 1; done

    # user/pass is configured in deployment.yml
    echo "User: user"
    echo "Pass: user"
    sleep 3
    firefox $url
    
    echo "Done"
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

function tearDown() {
    stage "Tear down"

    kubectl delete ingress $INGRESS_NAME
    kubectl delete service $SERVICE_NAME
    kubectl delete replicaset $REPLICASET_NAME

    echo "Done"
    exit 0
}

checkPrerequsites
runMinikube
configIngress
createReplicaSetServiceIngress
patchIngressHost
showWebPage
keepAlive