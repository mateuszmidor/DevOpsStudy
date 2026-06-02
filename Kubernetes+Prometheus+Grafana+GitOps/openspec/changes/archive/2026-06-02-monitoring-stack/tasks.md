## 1. Bootstrap Helm releases

- [x] 1.1 Create `Makefile` with `default` target: add Helm repos (prometheus-community, grafana), update repos
- [x] 1.2 Add helm upgrade --install commands to Makefile for `kube-prometheus-stack` (grafana.enabled=false) and `grafana-operator`
- [x] 1.3 Verify `make` runs without errors on a clean Minikube cluster

## 2. Create Grafana instance CRD

- [x] 2.1 Write `01-grafana-instance.yaml` — `Grafana` CR with 2Gi PVC, label `dashboards: gitops`, console logging, anonymous auth disabled
- [x] 2.2 Add `kubectl apply -f 01-grafana-instance.yaml` to `make obs` in Makefile
- [x] 2.3 Verify Grafana pod starts and admin credentials secret is created

## 3. Configure Prometheus datasource

- [x] 3.1 Write `02-datasource.yaml` — `GrafanaDatasource` CR with `uid: prometheus-gitops`, URL `http://prometheus-operated.monitoring.svc.cluster.local:9090`, default true
- [x] 3.2 Add to `make obs`

## 4. Create Observability dashboard

- [x] 4.1 Write `03-dashboard.yaml` — `GrafanaDashboard` CR with inline JSON model containing a single stat panel
- [x] 4.2 Dashboard panel uses query: `sum(kube_pod_status_phase{namespace="default", phase="Running"})`
- [x] 4.3 Add to `make obs`

## 5. Create alert folder

- [x] 5.1 Write `04-folder.yaml` — `GrafanaFolder` CR titled "Infrastructure Alerts"
- [x] 5.2 Add to `make obs`

## 6. Configure MS Teams contact point and notification policy

- [x] 6.1 Write `05-contact-point.yaml` — `GrafanaContactPoint` CR with `type: teams`, URL `https://webhook.site/2e5e7bcf-c8b6-46a3-9045-93f528b55e34`
- [x] 6.2 Write `06-notification-policy.yaml` — `GrafanaNotificationPolicy` CR routing all alerts to `ms-teams-channel`, grouped by `alertname`, `namespace`
- [x] 6.3 Add both to `make obs`

## 7. Create pod count alert rule

- [x] 7.1 Write `07-alert-rule.yaml` — `GrafanaAlertRuleGroup` CR with single rule "Default Namespace Pod Count Critical"
- [x] 7.2 Alert condition: `sum(kube_pod_status_phase{namespace="default", phase="Running"})` > 3 for 1 minute
- [x] 7.3 Use 3-stage pipeline: query A → reduce B → threshold C
- [x] 7.4 Reference datasource by `uid: prometheus-gitops` and folder by `folderRef: infrastructure-alerts-folder`
- [x] 7.5 Add to `make obs`

## 8. End-to-end verification

- [x] 8.1 Run `make` on Minikube, confirm no errors
- [x] 8.2 Run `make obs`, confirm all resources created
- [x] 8.3 Port-forward Grafana service and verify dashboard shows pod count
- [x] 8.4 Deploy 4+ pods in default namespace, verify alert fires
- [x] 8.5 Verify webhook.site receives alert notification
