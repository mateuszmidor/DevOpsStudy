# ctlptl + kind for creating local Kubernetes clusters

- ctlptl (cattle patrol) - create/delete kubernets clusters using minikube/kind/k3d/others; this is kind of wrapper for cluster-creating tools
- kind - tool for running local kubernetes clusters, designed for testing kubernetes itself; alternative to minikube

## Install

1. Install `ctlptl`:
    ```sh
    go install github.com/tilt-dev/ctlptl/cmd/ctlptl@latest
    ```
1. Install `kind`:
    ```sh
    go install sigs.k8s.io/kind@v0.20.0 
    ```

## Create 1-node cluster with ctlptl (don't know how to create >1 nodes cluster with ctlptl)

```sh
ctlptl create cluster kind --name=kind-1-node # name must be prefixed with "kind"
```
, result:
```sh
kubectl get node
NAME                   STATUS   ROLES           AGE   VERSION
1-node-control-plane   Ready    control-plane   45s   v1.27.3
```

### Delete

```sh
ctlptl delete cluster kind-1-node
```

## Create 3-nodes cluster with raw kind

```sh
kind create cluster --name=3-nodes --config kind-3-nodes.yaml
```
, result:
```sh
kubectl get node
NAME                         STATUS   ROLES           AGE   VERSION
kind-3-nodes-control-plane   Ready    control-plane   53s   v1.27.3
kind-3-nodes-worker          Ready    <none>          30s   v1.27.3
kind-3-nodes-worker2         Ready    <none>          31s   v1.27.3
```

### Delete

```sh
kind delete cluster --name=3-nodes
```
