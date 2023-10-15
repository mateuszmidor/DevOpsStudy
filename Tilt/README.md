# Tilt

A tool for running your kubernetes applications on local cluster using minikube/kind/k3d/others https://tilt.dev/

## Install (Linux, tested on Manjaro, 14.10.2023)

https://docs.tilt.dev/install.html:

1. Install Docker and configure it to be non-root
1. Install kubectl
1. Install `ctlptl` ("cattle patrol") -  CLI for declaratively setting up local Kubernetes clusters using minikube/kind/k3d/others:
    ```sh
    go install github.com/tilt-dev/ctlptl/cmd/ctlptl@latest
    ```
1. Install `tilt`:
    ```sh
    curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
    ```

## Run

```sh
tilt up
...
tilt down
```
