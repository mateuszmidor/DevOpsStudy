# 0001. Separate Grafana Operator from Prometheus metrics backend

- Status: accepted
- Date: 2026-06-02

## Context

A monitoring stack for a local Minikube cluster needs both metrics collection (Prometheus) and visualization (Grafana). The `kube-prometheus-stack` Helm chart bundles both together in a single release. However, Prometheus is planned as a temporary metrics backend that will be replaced later. Bundling Grafana with Prometheus would couple the visualization layer to a temporary component, forcing both to be replaced together.

The Grafana Operator (`grafana.integreatly.org/v1beta1`) provides CRDs for managing Grafana resources (instance, datasources, dashboards, alert rules, contact points, notification policies) as first-class Kubernetes resources. The Prometheus Operator (`monitoring.coreos.com/v1`) handles scraping and alerting.

Minikube supports Helm charts and CRDs without additional tooling.

## Decision

Install two separate Helm charts:
1. `kube-prometheus-stack` with `grafana.enabled=false` — provides Prometheus Operator, Prometheus, Alertmanager, kube-state-metrics
2. `grafana-operator` — provides the Grafana Operator and CRDs for managing Grafana declaratively

All Grafana-side configuration is managed via Grafana Operator CRDs. The Prometheus datasource in Grafana points to `prometheus-operated.monitoring.svc.cluster.local:9090`. When Prometheus is replaced, only this URL changes.

## Consequences

**Positive:**
- Prometheus can be replaced (e.g., with VictoriaMetrics, Thanos, or a hosted service) without touching Grafana, dashboards, or alert rules
- Grafana configuration is fully declarative via CRDs (pure GitOps)
- Dashboard and alert definitions live in the repo as Kubernetes manifests
- Standard Kubernetes RBAC and namespace isolation apply

**Negative:**
- Two Helm releases to manage instead of one
- Alert evaluation depends on Grafana uptime (not Prometheus Alertmanager)
- Slightly more CRDs and YAML files in the repo
