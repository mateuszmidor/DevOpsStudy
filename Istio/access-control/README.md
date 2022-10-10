# Deny all traffic in "default" namespace, then explicitly enable traffic for ingress-frontend and frontend-customers

Based on https://academy.tetrate.io/courses/take/istio-fundamentals/lessons/19068842-lab-2-access-control

## Prerequisites

- clean minikube cluster
- Istio Demo profile installed
- `default` namespace labeled for istio sidecar auto-injection: istio-injection=enabled

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

- create the Frontend with it's own ServiceAccount
    ```sh
    kubectl apply -f web-frontend.yaml
    kubectl get deploy,pod,sa,svc,vs
    NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/web-frontend   1/1     1            1           7s

    NAME                                READY   STATUS    RESTARTS   AGE
    pod/web-frontend-74dd5cbcdc-l4w97   2/2     Running   0          7s

    NAME                          SECRETS   AGE
    serviceaccount/default        1         247d
    serviceaccount/web-frontend   1         7s

    NAME                   TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
    service/kubernetes     ClusterIP   10.96.0.1     <none>        443/TCP   247d
    service/web-frontend   ClusterIP   10.98.2.132   <none>        80/TCP    7s

    NAME                                              GATEWAYS      HOSTS   AGE
    virtualservice.networking.istio.io/web-frontend   ["gateway"]   ["*"]   7s
	```

- create Customers V1 with it's own ServiceAccount
    ```sh
    kubectl apply -f customers-v1.yaml
    kubectl get deploy,pod,sa,svc,vs
    NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/customers-v1   1/1     1            1           44s
    deployment.apps/web-frontend   1/1     1            1           2m19s

    NAME                                READY   STATUS    RESTARTS   AGE
    pod/customers-v1-75d7677d5-6sfwf    2/2     Running   0          44s
    pod/web-frontend-74dd5cbcdc-l4w97   2/2     Running   0          2m19s

    NAME                          SECRETS   AGE
    serviceaccount/customers-v1   1         44s
    serviceaccount/default        1         247d
    serviceaccount/web-frontend   1         2m19s

    NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    service/customers      ClusterIP   10.103.125.38   <none>        80/TCP    44s
    service/kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP   247d
    service/web-frontend   ClusterIP   10.98.2.132     <none>        80/TCP    2m19s

    NAME                                              GATEWAYS      HOSTS                                     AGE
    virtualservice.networking.istio.io/customers                    ["customers.default.svc.cluster.local"]   44s
    virtualservice.networking.istio.io/web-frontend   ["gateway"]   ["*"]                                     2m19s
    ```

- see the app works 
    ```sh
    curl $GATEWAY_URL
    ```

- create deny-all AuthorizationPolicy
    ```sh
    kubectl apply -f deny-all.yaml 
    kubectl get authorizationpolicy
    NAME       AGE
    deny-all   13s
    ```

- and see the app stops working - all communication in `default` namespace is denied 
    ```sh
    curl $GATEWAY_URL
    "RBAC: access denied"
    ```

- allow communication ingress-frontend and frontend-customers
    ```sh
    kubectl apply -f allow-ingress-frontend-customers.yaml
    kubectl get authorizationpolicy
    NAME                           AGE
    allow-ingress-frontend         46s
    allow-web-frontend-customers   46s
    deny-all                       4m41s
    ```

- and see the app is working again
    ```sh
    curl $GATEWAY_URL
    ```

- wget frontend and customers from inside the cluster and see http 403 - the busybox workload is not authorized to communicate within the cluster
    ```sh
    kubectl run busybox --image busybox -it -- sh
    
    wget web-frontend.default.svc.cluster.local
    Connecting to web-frontend.default.svc.cluster.local (10.98.2.132:80)
    wget: server returned error: HTTP/1.1 403 Forbidden
    
    wget customers.default.svc.cluster.local
    Connecting to customers.default.svc.cluster.local (10.103.125.38:80)
    wget: server returned error: HTTP/1.1 403 Forbidden
    ```
    , it will work if you run it with customers service account, though
    ```sh
    kubectl run busybox2 --image busybox --serviceaccount customers-v1 -it -- sh

    wget customers.default.svc.cluster.local
    Connecting to customers.default.svc.cluster.local (10.104.156.30:80)
    saving to 'index.html'
    ```

## Clean Up

```sh
kubectl delete -f .
```