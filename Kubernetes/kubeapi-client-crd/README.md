# Kube API golang client interacting with CRD from inside or outside the cluster

client-go module: https://github.com/kubernetes/client-go

## This example will list, patch, then list again WasmPlugins (Istio's CRD)

```sh
make docker
kubectl apply -f rbac.yaml # allow the POD interact with KubeAPI
kubectl apply -f wasm-plugin.yaml # deploy wasm plugin
kubectl apply -f pod.yaml
kubectl logs k8s-api-client-crd -f
``` 