## ADDED Requirements

### Requirement: Grafana access documentation
Feature: Grafana access guide
Rule: The repository root README must document how to access Grafana and retrieve admin credentials after deployment

#### Scenario: Document deployment prerequisites
- **GIVEN** a fresh Minikube cluster
- **WHEN** a user reads the README
- **THEN** the README lists Minikube and `kubectl` as prerequisites
- **AND** the README documents the two-step deploy: `make` followed by `make obs`

#### Scenario: Document admin password retrieval
- **GIVEN** the Grafana Operator has created the `gitops-grafana-admin-credentials` secret in the `monitoring` namespace
- **WHEN** a user reads the README
- **THEN** the README provides the command: `kubectl get secret gitops-grafana-admin-credentials -n monitoring -o jsonpath='{.data.GF_SECURITY_ADMIN_PASSWORD}' | base64 -d`
- **AND** the README states that the username is `admin`

#### Scenario: Document Grafana UI access
- **GIVEN** the Grafana instance `gitops-grafana` is running in the `monitoring` namespace
- **WHEN** a user reads the README
- **THEN** the README provides the port-forward command: `kubectl port-forward svc/gitops-grafana-service 3000:3000 -n monitoring`
- **AND** the README states the Grafana UI is available at `http://localhost:3000`
