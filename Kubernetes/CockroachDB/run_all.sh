#!/usr/bin/env bash

trap tearDown SIGINT

RELEASE_NAME="mycluster"
POD0_NAME="$RELEASE_NAME-cockroachdb-0" # first pod in stateful set; can connect postgresql client here

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

    command helm > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install helm to run this example" && exit 1

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

function runCockroachDBCluster() {
    stage "Running CockroachDB cluster"

    helm repo add cockroachdb https://charts.cockroachdb.com/
    helm repo update
    helm install -f values.yaml $RELEASE_NAME cockroachdb/cockroachdb

    echo "Done"
}

function waitClusterReady() {
    stage "Waiting cluster ready"
    
    while true; do 
       kubectl wait pod/$POD0_NAME --for condition=Ready --timeout=60s # wait POD-0 is ready in statefulset
       [[ $? == 0 ]] && break
       echo "waiting..."
       sleep 3
    done

    echo "Done"
}

function writeData() {
    stage "Writing data to cluster"

    create_table="CREATE TABLE IF NOT EXISTS sevenwonders(name varchar(64), location varchar(128));"
    kubectl exec $POD0_NAME -- cockroach sql --insecure --execute="$create_table"

    write_data="INSERT INTO sevenwonders(name, location) VALUES('GreatWall', 'China'), ('MachuPicchu', 'Peru'), ('GreatPyramid', 'Egypt');"
    kubectl exec $POD0_NAME -- cockroach sql --insecure --execute="$write_data"

    echo "Done"
}

function readData() {
    stage "Reading data from cluster"

    read_data="SELECT * from sevenwonders;"
    kubectl exec $POD0_NAME -- cockroach sql --insecure --execute="$read_data"

    echo "Done"
}

function showClusterConnectionString() {
    stage "db connection string"

    SERVICE_NAME="$RELEASE_NAME-cockroachdb-public"
    grpcport=`kubectl get svc $SERVICE_NAME -o jsonpath='{.spec.ports[0].nodePort}'` # sql connection port
    httpport=`kubectl get svc $SERVICE_NAME -o jsonpath='{.spec.ports[1].nodePort}'` # webui http port

    IP=`minikube ip`
    echo "postgresql://root@$IP:$grpcport/defaultdb?sslmode=disable"
    echo "CockroachDB WebUI: $IP:$httpport"

    echo "Done"
}

function tearDown() {
    stage "Tear down"

    helm uninstall $RELEASE_NAME

    echo "Done"
    exit 0
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

checkPrerequsites
runMinikube
runCockroachDBCluster
waitClusterReady
writeData
readData
showClusterConnectionString
keepAlive
