# Multus CNI example

Multus is CNI multiplexer - allows for attaching multiple networks to single POD.  
This example shows how one can create a custom Network Attachment (visible in POD as network interface), and start server listening on that Network Attachment.  
Sources:
- https://github.com/k8snetworkplumbingwg/multus-cni/blob/master/docs/quickstart.md
- https://www.youtube.com/watch?v=FwhVJ_e8cW0

## Run Minikube with Multus

1. Run cluster with Cilium as default CNI:
    ```sh
    minikube delete # need to start cluster from scratch
    minikube start --cni=cilium # cilium is a requirement, standard bridge won't work properly with multus
    kubectl get pod -n kube-system # wait till Cilium pods are running
    ```

1. Deploy Multus:

    ```sh
    kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset.yml
    kubectl get pod -n kube-system # wait till Multus pods are running
    ```

## Run demo client-server talking over custom network

1. Create Network Attachment 

    ```sh
    kubectl apply -f network-attachment-definition.yaml
    kubectl get network-attachment-definitions
    NAME           AGE
    macvlan-conf   10s
    ``` 

1. Create http client and server communicating over attached network and see client successfuly connects to server

    ```text
    kubectl apply -f client_server.yaml
    kubectl logs client

    <!DOCTYPE HTML>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <title>Directory listing for /</title>
    </head>
    <body>
    <h1>Directory listing for /</h1>
    <hr>
    <ul>
    <li><a href=".dockerenv">.dockerenv</a></li>
    <li><a href="bin/">bin/</a></li>
    <li><a href="dev/">dev/</a></li>
    <li><a href="etc/">etc/</a></li>
    <li><a href="home/">home/</a></li>
    <li><a href="lib/">lib/</a></li>
    <li><a href="media/">media/</a></li>
    <li><a href="mnt/">mnt/</a></li>
    <li><a href="opt/">opt/</a></li>
    <li><a href="proc/">proc/</a></li>
    <li><a href="root/">root/</a></li>
    <li><a href="run/">run/</a></li>
    <li><a href="sbin/">sbin/</a></li>
    <li><a href="srv/">srv/</a></li>
    <li><a href="sys/">sys/</a></li>
    <li><a href="tmp/">tmp/</a></li>
    <li><a href="usr/">usr/</a></li>
    <li><a href="var/">var/</a></li>
    </ul>
    <hr>
    </body>
    </html>
    ```

1. See server interfaces - `my-intf` with static IP `192.168.1.88/24` is the custom attached one

    ```sh
    kubectl exec server -it -- ip a
    
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever

    2: my-intf@if13: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
        link/ether 9e:01:54:8c:7d:cd brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.88/24 brd 192.168.1.255 scope global my-intf
        valid_lft forever preferred_lft forever

    353: eth0@if354: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
        link/ether 2a:a5:46:90:9c:fe brd ff:ff:ff:ff:ff:ff
        inet 10.244.0.114/32 scope global eth0
        valid_lft forever preferred_lft forever
    ```


1. See server attached networks

    ```sh
    kubectl describe pod server
    ...
    Annotations:      k8s.v1.cni.cncf.io/network-status:
                        [{
                            "name": "cilium",
                            "interface": "eth0",
                            "ips": [
                                "10.244.0.114"
                            ],
                            "mac": "2a:a5:46:90:9c:fe",
                            "default": true,
                            "dns": {}
                        },{
                            "name": "default/macvlan-conf",
                            "interface": "my-intf",
                            "ips": [
                                "192.168.1.88"
                            ],
                            "mac": "9e:01:54:8c:7d:cd",
                            "dns": {}
                        }]
                    k8s.v1.cni.cncf.io/networks:
                        [ { "name": "macvlan-conf", "interface": "my-intf", "ips": [ "192.168.1.88/24" ], "gateway": [ "192.168.1.254" ] } ]
    ...
    ``` 
