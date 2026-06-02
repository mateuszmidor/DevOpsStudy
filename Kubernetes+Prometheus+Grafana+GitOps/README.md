# K8S Prometheus Grafana GitOps

Observability stack for a Minikube cluster using Prometheus Operator and Grafana Operator with GitOps-friendly CRDs.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed and running
- `kubectl` configured for your Minikube cluster

## Deploy

```sh
# Bootstrap Helm repositories and install Prometheus Operator + Grafana Operator
make

# Apply Grafana CRDs (instance, datasource, dashboard, alerts)
make obs
```

## Access Grafana

Forward the Grafana service to your local machine:

```sh
kubectl port-forward svc/gitops-grafana-service 3000:3000 -n monitoring
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Credentials

- **Username:** `admin`
- **Password:** Retrieve from the auto-generated secret:

```sh
kubectl get secret gitops-grafana-admin-credentials -n monitoring -o jsonpath='{.data.GF_SECURITY_ADMIN_PASSWORD}' | base64 -d
```
