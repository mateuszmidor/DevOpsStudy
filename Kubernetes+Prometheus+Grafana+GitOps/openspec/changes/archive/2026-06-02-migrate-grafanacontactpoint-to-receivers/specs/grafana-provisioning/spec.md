## MODIFIED Requirements

### Requirement: MS Teams contact point
Grafana MUST send alert notifications to a Microsoft Teams channel via webhook
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
