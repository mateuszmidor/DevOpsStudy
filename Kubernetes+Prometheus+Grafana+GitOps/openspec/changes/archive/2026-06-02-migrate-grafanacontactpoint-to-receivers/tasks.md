## 1. Migrate the YAML file

- [x] 1.1 Edit `05-contact-point.yaml`: move top-level `type` and `settings` into a `receivers[]` entry with structure `receivers[0].type: teams` and `receivers[0].settings.url: <webhook-url>`
- [x] 1.2 Verify the file validates against the Grafana Operator CRD schema with `kubectl apply --dry-run=server -f 05-contact-point.yaml`

## 2. Verify

- [x] 2.1 Run `kubectl apply -f 05-contact-point.yaml` and confirm the GrafanaContactPoint is created/updated successfully
- [x] 2.2 Check Grafana UI that the `ms-teams-channel` contact point still functions correctly <!-- Manual step: verify in Grafana UI under Alerting > Contact points that ms-teams-channel is listed and test notifications work -->
- [x] 2.3 Run `openspec validate migrate-grafanacontactpoint-to-receivers --type change --strict`
