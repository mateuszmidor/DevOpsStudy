# Advanced traffic routing using Virtual Service + SubSets - routing based on http headers

Based on https://academy.tetrate.io/courses/take/istio-fundamentals/lessons/19068805-lab-4-advanced-traffic-routing  
For step-by-step configuration example, see [simple-traffic-routing](../simple-traffic-routing/README.md)

## Prerequisites

- clean minikube cluster
- Istio Demo profile installed
- `default` namespace labeled for istio sidecar auto-injection: istio-injection=enabled

## Steps 

- create all the resources. Header matching happens in `customers.yaml` `VirtualService`
	```sh
	kubectl apply -f .
    kubectl get deploy,pod,svc,gateway,dr,vs  
    NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/customers-v1   1/1     1            1           90s
    deployment.apps/customers-v2   1/1     1            1           90s
    deployment.apps/web-frontend   1/1     1            1           90s

    NAME                                READY   STATUS    RESTARTS   AGE
    pod/customers-v1-7b5b4b76fc-nf8d8   2/2     Running   0          90s
    pod/customers-v2-6bc699b6cc-m7ww5   2/2     Running   0          90s
    pod/web-frontend-69b64f974c-ttxkq   2/2     Running   0          90s

    NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
    service/customers      ClusterIP   10.102.160.24    <none>        80/TCP    90s
    service/kubernetes     ClusterIP   10.96.0.1        <none>        443/TCP   242d
    service/web-frontend   ClusterIP   10.110.226.204   <none>        80/TCP    90s

    NAME                                  AGE
    gateway.networking.istio.io/gateway   90s

    NAME                                            HOST                                  AGE
    destinationrule.networking.istio.io/customers   customers.default.svc.cluster.local   90s

    NAME                                              GATEWAYS      HOSTS                                     AGE
    virtualservice.networking.istio.io/customers                    ["customers.default.svc.cluster.local"]   90s
    virtualservice.networking.istio.io/web-frontend   ["gateway"]   ["*"]                                     90s
	```

- get and remember ingress IP (minikube tunnel first, to get External IP)
    ```sh
    kubectl get svc -n istio-system -l app=istio-ingressgateway
    NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                                                                      AGE
    istio-ingressgateway   LoadBalancer   10.98.23.63   10.98.23.63   15021:30356/TCP,80:32547/TCP,443:32524/TCP,31400:30726/TCP,15443:30339/TCP   4d4h
    export GATEWAY_URL=10.98.23.63
    ```

- request with header - returns table with `CITY` and `NAME` columns
    ```sh
    curl -H "user:debug" $GATEWAY_URL | grep '<th '
                <th class="px-4 py-2">CITY</th>
                <th class="px-4 py-2">NAME</th>
    ```

- request without header - returns table with `NAME` column only
    ```sh
    curl $GATEWAY_URL | grep '<th '
                <th class="px-4 py-2">NAME</th>
    ```

    
## Clean Up

```sh
kubectl delete -f .
```