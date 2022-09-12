# Basic Istio application deployment - Hello World webapp

Based on https://academy.tetrate.io/courses/take/istio-fundamentals/lessons/19068812-lab-1-gateways

## Prerequisites

- clean minikube cluster
- Istio Demo profile installed
- `default` namespace labeled as istio-injection=enabled

## Steps 

- create Ingress Gateway
	```sh
	kubectl apply -f gateway.yaml
    kubectl get gateway
    NAME               AGE
    gateway            13m    
	```

- get and remember ingress IP (minikube tunnel first, to get External IP)
    ```sh
    kubectl get svc -n istio-system -l app=istio-ingressgateway
    NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                                                                      AGE
    istio-ingressgateway   LoadBalancer   10.98.23.63   10.98.23.63   15021:30356/TCP,80:32547/TCP,443:32524/TCP,31400:30726/TCP,15443:30339/TCP   4d4h
    export GATEWAY_URL=10.98.23.63
    ```

- create the application (deployment + service)
    ```sh
    kubectl apply -f app.yaml
    kubectl get deploy,pod,svc
    NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/hello-world   1/1     1            1           13m

    NAME                              READY   STATUS    RESTARTS   AGE
    pod/hello-world-85c8685dd-j5zxh   2/2     Running   0          13m

    NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    service/hello-world   ClusterIP   10.100.227.71   <none>        80/TCP    13m
    service/kubernetes    ClusterIP   10.96.0.1       <none>        443/TCP   237d
    ```
    Envoy proxy sidecar is automatically injected in the application's Pod

- create Virtual Service
    ```sh
    kubectl apply -f virtual-service.yaml
    kubectl get vs
    NAME          GATEWAYS               HOSTS   AGE
    hello-world   ["gateway"]            ["*"]   30s
    ```

- send GET request
    ```sh
    curl -v $GATEWAY_URL
    *   Trying 10.98.23.63:80...
    * Connected to 10.98.23.63 (10.98.23.63) port 80 (#0)
    > GET / HTTP/1.1
    > Host: 10.98.23.63
    > User-Agent: curl/7.74.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < date: Fri, 02 Sep 2022 12:25:24 GMT
    < content-length: 11
    < content-type: text/plain; charset=utf-8
    < x-envoy-upstream-service-time: 1
    < server: istio-envoy
    < 
    * Connection #0 to host 10.98.23.63 left intact
    Hello World
    ```
    
## Clean Up

```sh
kubectl delete deploy hello-world  
kubectl delete service hello-world  
kubectl delete vs hello-world  
kubectl delete gateway gateway  
```