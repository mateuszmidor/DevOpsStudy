## Why

Minikube cluster lacks observability. Need a GitOps-friendly monitoring stack to track cluster health now, with the ability to swap out Prometheus for a different metrics backend later without rebuilding the observability layer.

## What Changes

- Add Helm-based bootstrap for Prometheus Operator (kube-prometheus-stack with Grafana disabled) and standalone Grafana Operator
- Provision Grafana instance via Grafana Operator CRD with 2Gi PVC
- Configure Prometheus datasource in Grafana via CRD
- Deploy a custom "Observability" dashboard with a single stat panel: running pod count in `default` namespace
- Create a Grafana alert rule: trigger critical when `default` namespace running pods > 3 for 1 minute
- Configure MS Teams webhook contact point and notification policy routing all alerts to it
- Add a `GrafanaFolder` CRD to organize alerts
- Create a Makefile to orchestrate bootstrap and apply steps in order

## Capabilities

### New Capabilities
- `grafana-provisioning`: CRD-driven Grafana instance provisioning, datasource, dashboard, folder, alert rules, contact point, and notification policy management via Grafana Operator
- `infra-orchestration`: Makefile-based orchestration of Helm bootstrap and kubectl apply steps

### Modified Capabilities

None. New repo, no existing specs.

## Impact

- New namespace `monitoring` created in the cluster
- Two Helm releases: `prometheus` (kube-prometheus-stack) and `grafana-operator`
- Grafana CRDs created under `grafana.integreatly.org/v1beta1` API group
- Prometheus Operator CRDs created under `monitoring.coreos.com/v1` API group
- 7-8 YAML files in the repo root for Kubernetes resources
- Persistent volume claim of 2Gi for Grafana data
