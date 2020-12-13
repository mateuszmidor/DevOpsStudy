#!/usr/bin/env bash

trap tearDown SIGINT

function stage() {
    BOLD_ORANGE="\e[1m\e[33m"
    RESET="\e[0m"
    msg="$1"
    
    echo
    echo -e "$BOLD_ORANGE$msg$RESET"
}

function checkPrerequsites() {
    stage "Checking prerequisites"

    command docker --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install docker to run this example" && exit 1

    command netcat --version > /dev/null 2>&1
    [[ $? != 0 ]] && echo "You need to install netcat to run this example" && exit 1

    echo "Done"
}

function runPrometheus() {
    stage "Running Prometheus"

    docker run -d --rm --name=my_prometheus --net=host -v `pwd`:/home  prom/prometheus --config.file="/home/prometheus-config.yml"

    echo "Find your metric 'wave' at localhost:9090"
    echo "Done"
}

function runGrafana() {
    stage "Running Grafana"
    
    docker run -d --rm --name=my_grafana --net=host -v `pwd`/datasources:/etc/grafana/provisioning/datasources grafana/grafana

    echo "User/Pass: admin/admin"
    echo "Find your metric 'wave'. Default scrape interval is 15s so the wave is a bit jagged :)"
    sleep 3
    firefox http://localhost:3000/explore
    
    echo "Done"
}

function runMetricProvider() {
    stage "Running 'wave' metric(a sinus function) provider at port 8080"

    SINUS="0.000000000000000 0.2588115870535327 0.49998662654663256 0.7070904020014415 0.8660099611064447 0.9659158336885827 0.999999998926914 0.9659398135111947 0.866056286662226 0.7071559164654717 0.5000668654782968 0.2589010826229296 0.0000000826229296 -0.25872208926231904 -0.49990638332273907 -0.7070248814672611 -0.8659636281162382 -0.965891845573885 -0.9999999903422263 -0.9659637850415149 -0.8661026047831848 -0.7072214248587892 -0.5001471001170429 -0.25899057596974184"
    HEADER="HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Encoding: identity\nServer: golang\nContent-Length: 19\nConnection: close" # Content-Lenght is important
   
    while true; do
        for s in $SINUS; do
            printf "$HEADER\n\nwave $s" | netcat  -l -p 8080 localhost
        done
    done

    echo "Done"
}


function tearDown() {
    stage "Tear down"

    docker stop my_prometheus
    docker stop my_grafana

    echo "Done"
    exit 0
}

function keepAlive() {
    stage "CTRL+C to exit"

    while true; do sleep 1; done
}

checkPrerequsites
runPrometheus
runGrafana
runMetricProvider
keepAlive
