## ADDED Requirements

### Requirement: Grafana instance provisioning
Feature: Grafana provisioning
Rule: A Grafana instance must be provisioned via the Grafana Operator CRD with a 2Gi persistent volume

#### Scenario: Deploy Grafana instance CRD
- **GIVEN** the Grafana Operator is installed in the `monitoring` namespace
- **WHEN** a `Grafana` CR (custom resource) named `gitops-grafana` is applied with label `dashboards: gitops` and a 2Gi PVC
- **THEN** the Grafana Operator creates a Grafana deployment and service named `gitops-grafana-service`
- **AND** the Grafana web UI is accessible on port 3000
- **AND** admin credentials are stored in a Kubernetes secret `gitops-grafana-admin-credentials`

### Requirement: Prometheus datasource
Rule: Grafana must have a Prometheus datasource configured pointing at the Prometheus Operator's in-cluster service

#### Scenario: Create Prometheus datasource
- **GIVEN** a running Grafana instance managed by the Grafana Operator
- **WHEN** a `GrafanaDatasource` CR is applied with `uid: prometheus-gitops` and `url: http://prometheus-operated.monitoring.svc.cluster.local:9090`
- **THEN** the datasource appears in Grafana's datasource list with name "Prometheus"
- **AND** the datasource is set as the default datasource

### Requirement: Observability dashboard
Rule: A dashboard named "Observability" must display the number of running pods in the `default` namespace as a single stat panel

#### Scenario: View pod count on dashboard
- **GIVEN** a Grafana instance with a Prometheus datasource
- **WHEN** a `GrafanaDashboard` CR is applied with an inline JSON model containing a stat panel with query `sum(kube_pod_status_phase{namespace="default", phase="Running"})`
- **THEN** the dashboard appears in Grafana under the "Observability" name
- **AND** the stat panel displays the current count of running pods in the `default` namespace
- **AND** the value updates every 15 seconds

### Requirement: Pod count alert
Rule: Grafana must fire a critical alert when the number of running pods in the `default` namespace exceeds 3 for 1 minute

#### Scenario: Alert fires on pod count threshold breach
- **GIVEN** the Grafana instance has a Prometheus datasource configured
- **WHEN** the number of running pods in the `default` namespace exceeds 3 for 1 minute
- **THEN** a Grafana alert rule named "Default Namespace Pod Count Critical" transitions to firing state
- **AND** the alert has labels `severity: critical`
- **AND** the alert description includes the current pod count

### Requirement: MS Teams contact point
Rule: Grafana must send alert notifications to a Microsoft Teams channel via webhook

#### Scenario: Configure Teams webhook contact point
- **GIVEN** a running Grafana instance
- **WHEN** a `GrafanaContactPoint` CR is applied with `receivers[].type: teams` and a valid webhook URL under `receivers[].settings.url`
- **THEN** the contact point appears in Grafana's alerting contact points list
- **AND** the contact point is named `ms-teams-channel`

#### Scenario: Route alerts to Teams
- **GIVEN** a `GrafanaContactPoint` named `ms-teams-channel` exists
- **WHEN** a `GrafanaNotificationPolicy` CR is applied with root route receiver set to `ms-teams-channel`
- **THEN** all fired alerts are routed to the MS Teams webhook
- **AND** alerts are grouped by `alertname` and `namespace`

### Requirement: Alert folder
Rule: Alert rules must be organized in a Grafana folder

#### Scenario: Create infrastructure alerts folder
- **GIVEN** a running Grafana instance
- **WHEN** a `GrafanaFolder` CR is applied with title "Infrastructure Alerts"
- **THEN** a folder named "Infrastructure Alerts" appears in Grafana's alerting UI
- **AND** the alert rule group can reference this folder via `folderRef`
