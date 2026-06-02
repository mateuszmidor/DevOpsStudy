## Context

Minikube cluster with no monitoring. Goal is a lightweight, GitOps-friendly observability stack using Kubernetes operators. Prometheus is a temporary metrics backend that will be replaced later, so Grafana must be independently managed (not embedded in the Prometheus stack).

The cluster runs on Minikube with default storage provisioner (standard).

## Goals / Non-Goals

**Goals:**
- Bootstrap Prometheus Operator and Grafana Operator via Helm
- Provision Grafana instance, datasource, dashboard, folder, contact point, notification policy, and alert rule via Grafana Operator CRDs
- "Observability" dashboard with a single stat panel showing `sum(kube_pod_status_phase{namespace="default", phase="Running"})`
- Alert when running pod count in `default` namespace > 3 for 1 minute
- MS Teams webhook notification for all alerts
- Makefile orchestration for repeatable bootstrap and apply

**Non-Goals:**
- Application-level service monitoring (ServiceMonitor/PodMonitor) — Prometheus is temporary
- High availability or multi-replica Grafana
- Persistent alert history or long-term metrics retention
- Authentication beyond default admin password
- ArgoCD/Flux reconciliation — manual `kubectl apply -f` from repo is sufficient

## Decisions

### Decision 1: Two-operator architecture

Prometheus Operator and Grafana Operator are separate Helm charts because Prometheus is temporary. When Prometheus is replaced, only the datasource URL changes — Grafana, dashboards, alerts remain untouched.

Alternatives considered:
- `kube-prometheus-stack` with built-in Grafana — simpler to install but couples metrics backend to visualization layer. Replacing Prometheus would require tearing down Grafana too.
- Standalone Grafana Helm chart — fewer CRDs but no GitOps-friendly resource management.

### Decision 2: GrafanaAlertRuleGroup over PrometheusRule

Grafana alert rules use the operator's `GrafanaAlertRuleGroup` CRD rather than Prometheus Operator's `PrometheusRule`. This keeps the alert lifecycle in Grafana's domain, which survives the Prometheus swap. Downside: alert evaluation depends on Grafana being up.

The rule uses a 3-stage expression pipeline (query → reduce → threshold) because Grafana's alerting engine requires this for threshold-based alerts from Prometheus queries.

### Decision 3: Inline dashboard JSON over Grafana.com import

The dashboard is a simple inline JSON definition in the `GrafanaDashboard` CRD rather than importing from Grafana.com. This keeps the dashboard definition self-contained in the repo with no external dependency.

### Decision 4: webhook.site for Teams integration

Using `https://webhook.site/2e5e7bcf-c8b6-46a3-9045-93f528b55e34` as the Teams-compatible webhook endpoint for initial testing. The `GrafanaContactPoint` uses `type: teams` which sends the correct payload format. Can be swapped for a real Teams webhook later.

### Decision 5: Ordered kubectl apply via Makefile

CRDs are applied in dependency order: Grafana instance first (other CRDs depend on the Grafana instance being available), then datasource/dashboard/folder, then contact point/notification policy, then alert rule (depends on folder and datasource).

## Risks / Trade-offs

- [PVC provisioning] Minikube's default storage provisioner may have slow PV provisioning. Grafana will be pending until PVC is bound. → Mitigation: Use 2Gi PVC which Minikube handles easily; if issues, add `storageClassName: standard`.
- [Alert dependency on Grafana] If Grafana goes down, alerts stop evaluating. → Accepted trade-off; Prometheus is temporary anyway.
- [webhook.site reliability] The webhook.site endpoint may expire or rate-limit. → Mitigation: Easy to swap URL; documented in Makefile.
- [kube-state-metrics dependency] The pod count query depends on `kube_pod_status_phase` metric, which requires `kube-state-metrics` (bundled with `kube-prometheus-stack`). → Confirmed: `kube-prometheus-stack` includes `kube-state-metrics` by default.

## Migration Plan

No migration needed — fresh cluster.

**Deploy:**
1. `make` — bootstrap Helm releases
2. `make obs` — apply CRDs in order
3. `kubectl port-forward svc/gitops-grafana-service 3000:3000 -n monitoring` — access Grafana
4. `kubectl get secret gitops-grafana-admin-credentials -n monitoring -o jsonpath='{.data.GF_SECURITY_ADMIN_PASSWORD}' | base64 -d` — get admin password

**Rollback:**
1. `helm uninstall prometheus -n monitoring`
2. `helm uninstall grafana-operator -n monitoring`
3. `kubectl delete namespace monitoring`

## Open Questions

None.
