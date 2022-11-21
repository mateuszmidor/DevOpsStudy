# Kube API golang client from inside the POD

This example will list all PODs running in the cluster:

```sh
make docker
kubectl apply -f rbac.yaml # allow the POD interact with KubeAPI
kubectl apply -f pod.yaml
kubectl logs k8s-api-client -f
``` 