## ADDED Requirements

### Requirement: Helm bootstrap orchestration
Feature: Infra orchestration
Rule: A Makefile target must bootstrap both Helm charts with correct settings

#### Scenario: Run make to bootstrap cluster monitoring
- **GIVEN** a running Minikube cluster with `kubectl` and `helm` installed
- **WHEN** `make` is executed from the repo root
- **THEN** the `prometheus-community` Helm repo is added
- **AND** the `grafana` Helm repo is added
- **AND** `kube-prometheus-stack` is installed in the `monitoring` namespace with `grafana.enabled=false`
- **AND** `grafana-operator` is installed in the `monitoring` namespace
- **AND** no errors occur during installation

### Requirement: CRD apply orchestration
Rule: A Makefile target must apply all CRD YAML files in the correct order

#### Scenario: Run make obs to apply observability CRDs
- **GIVEN** the Prometheus Operator and Grafana Operator are running in the `monitoring` namespace
- **WHEN** `make obs` is executed from the repo root
- **THEN** `01-grafana-instance.yaml` is applied
- **AND** `02-datasource.yaml` is applied
- **AND** `03-dashboard.yaml` is applied
- **AND** `04-folder.yaml` is applied
- **AND** `05-contact-point.yaml` is applied
- **AND** `06-notification-policy.yaml` is applied
- **AND** `07-alert-rule.yaml` is applied
- **AND** all resources are created successfully in the cluster
