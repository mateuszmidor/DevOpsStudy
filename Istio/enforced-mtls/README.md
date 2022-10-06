# Enable mTLS in STRICT mode - workloads need to have sidecars injected for mTLS to work

Based on https://academy.tetrate.io/courses/take/istio-fundamentals/lessons/19068845-lab-1-enable-mtls

## Prerequisites

- clean minikube cluster
- Istio Demo profile installed

## Steps 

- create the Gateway
	```sh
	kubectl apply -f gateway.yaml
    kubectl get gateway
    NAME      AGE
    gateway   4s
    ```

- get and remember ingress IP (minikube tunnel first, to get External IP)
    ```sh
    kubectl get svc -n istio-system -l app=istio-ingressgateway
    NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                                                                      AGE
    istio-ingressgateway   LoadBalancer   10.98.23.63   10.98.23.63   15021:30356/TCP,80:32547/TCP,443:32524/TCP,31400:30726/TCP,15443:30339/TCP   4d4h
    export GATEWAY_URL=10.98.23.63
    ```

- create the Frontend but without envoy-sidecar injected
    ```sh
    kubectl label ns default istio-injection- # disable sidecar injection
    kubectl apply -f web-frontend.yaml
    kubectl label ns default istio-injection=enabled # re-enable sidecar injection
    kubectl get deploy,pod,svc,vs  
    NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/web-frontend   1/1     1            1           59s

    NAME                                READY   STATUS    RESTARTS   AGE
    pod/web-frontend-69b64f974c-j5kw7   1/1     Running   0          59s

    NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    service/kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP   247d
    service/web-frontend   ClusterIP   10.99.100.162   <none>        80/TCP    59s

    NAME                                              GATEWAYS      HOSTS   AGE
    virtualservice.networking.istio.io/web-frontend   ["gateway"]   ["*"]   59s
	```
    , see there is only one container running in the pod/web-frontend-69b64f974c-j5kw7 - no envoy sidecar

- create Customers V1
    ```sh
    kubectl apply -f customers-v1.yaml
    kubectl get deploy,pod,svc,vs 
    NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/customers-v1   1/1     1            1           12s
    deployment.apps/web-frontend   1/1     1            1           19m

    NAME                                READY   STATUS    RESTARTS   AGE
    pod/customers-v1-7b5b4b76fc-g7m78   2/2     Running   0          12s
    pod/web-frontend-69b64f974c-j5kw7   1/1     Running   0          19m

    NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    service/customers      ClusterIP   10.102.28.192   <none>        80/TCP    12s
    service/kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP   247d
    service/web-frontend   ClusterIP   10.99.100.162   <none>        80/TCP    19m

    NAME                                              GATEWAYS      HOSTS                                     AGE
    virtualservice.networking.istio.io/customers      ["gateway"]   ["customers.default.svc.cluster.local"]   12s
    virtualservice.networking.istio.io/web-frontend   ["gateway"]   ["*"]                                     19m
    ```

- see the app works - Frontend svc can access Customers svc even though Frontend has no proxy sidecar
    ```sh
    curl $GATEWAY_URL
    ```
    , this works because communication is in PERMISSIVE mode - plain text traffic is allowed

- set communication to STRICT mode (to require mTSL)
    ```sh
    kubectl apply -f strict-mtls.yaml
    kubectl get peerauthentication
    NAME      MODE     AGE
    default   STRICT   11s
    ```
- and see the app stops working - Frontend can't access Customers - Frontend has no sidecar so the required mTLS is not possible
    ```sh
    curl $GATEWAY_URL
    "read ECONNRESET"
    ```

- notice that you can still access the Customers through the Gateway as they have mTLS working
    ```sh
    curl -H "Host: customers.default.svc.cluster.local"  $GATEWAY_URL
    [{"name":"Jewel Schaefer"},{"name":"Raleigh Larson"},{"name":"Eloise Senger"},{"name":"Moshe Zieme"},{"name":"Filiberto Lubowitz"},{"name":"Ms.Kadin Kling"},{"name":"Jennyfer Bergstrom"},{"name":"Candelario Rutherford"},{"name":"Kenyatta Flatley"},{"name":"Gianni Pouros"}]
    ```

- now manually inject proxy sidecar into web-frontend and see the app works again - mTLS is working
    ```sh
    kubectl apply -f <(istioctl kube-inject -f web-frontend.yaml)
    curl $GATEWAY_URL
    ```

## Clean Up

```sh
kubectl delete -f .
```