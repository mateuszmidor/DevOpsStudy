## Why

The MS Teams webhook URL for the GrafanaContactPoint is currently hardcoded as a plaintext string in `05-contact-point.yaml`. Webhook URLs are sensitive credentials — they grant write access to a Teams channel. Storing them in a Kubernetes Secret rather than inline in the manifest follows security best practices and aligns with how other sensitive values (e.g., Grafana admin credentials via `gitops-grafana-admin-credentials`) are already handled in this project.

## What Changes

- Create a new `05-contact-point-url-secret.yaml` with a `kind: Secret` containing the MS Teams webhook URL in `stringData`
- Update `05-contact-point.yaml` to reference the webhook URL from the Secret via `valuesFrom[].targetPath: url` instead of a hardcoded `settings.url`
- Renumber downstream YAML files: `05-contact-point.yaml` → `06-contact-point.yaml`, `06-notification-policy.yaml` → `07-notification-policy.yaml`, `07-alert-rule.yaml` → `08-alert-rule.yaml`
- Update the `grafana-provisioning` spec to reflect that the webhook URL is sourced from a Kubernetes Secret

## Capabilities

### New Capabilities

None — behavior is unchanged.

### Modified Capabilities

- `grafana-provisioning`: The "MS Teams contact point" requirement's "Configure Teams webhook contact point" scenario is updated to reflect that the webhook URL comes from a Kubernetes Secret via `valuesFrom`, rather than being hardcoded inline.

## Impact

- Three YAML files renamed (05→06, 06→07, 07→08)
- One YAML file created (`05-contact-point-url-secret.yaml`)
- One YAML file edited (`05-contact-point.yaml` → `06-contact-point.yaml`): URL moves from `settings.url` to `valuesFrom[].secretKeyRef`
- One spec file updated (`openspec/specs/grafana-provisioning/spec.md`)
- `kubectl apply` ordering changes: the Secret is applied before the contact point references it
