# Kube API golang client interacting with core api from inside the cluster

client-go module: https://github.com/kubernetes/client-go

## This example will list all PODs running in the cluster (using Core API):

```sh
make docker
kubectl apply -f rbac.yaml # allow the POD interact with KubeAPI
kubectl apply -f pod.yaml
kubectl logs k8s-api-client -f
``` 