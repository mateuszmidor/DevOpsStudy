## 1. Create the Secret YAML

- [x] 1.1 Create `05-contact-point-url-secret.yaml` with `kind: Secret`, `name: contact-point-url`, `namespace: monitoring`, and `stringData.url` set to the `webhook.site` test URL with a `# REPLACE ME` comment

## 2. Update the contact point YAML

- [x] 2.1 Rename `05-contact-point.yaml` → `06-contact-point.yaml`
- [x] 2.2 Replace the hardcoded `settings.url` with `settings: {}` and add `valuesFrom[0].targetPath: url` referencing the `contact-point-url` secret key `url`

## 3. Update Makefile

- [x] 3.1 Update `Makefile` `obs:` target to use new file names (`05-contact-point-url-secret.yaml`, `06-contact-point.yaml`, `07-notification-policy.yaml`, `08-alert-rule.yaml`)

## 4. Renumber downstream YAML files

- [x] 4.1 Rename `06-notification-policy.yaml` → `07-notification-policy.yaml`
- [x] 4.2 Rename `07-alert-rule.yaml` → `08-alert-rule.yaml`

## 5. Update specs

- [x] 5.1 Update `openspec/specs/grafana-provisioning/spec.md` to reflect the webhook URL is sourced from a Kubernetes Secret

## 6. Verify

- [x] 6.1 Run `kubectl apply --dry-run=server -f 05-contact-point-url-secret.yaml` and confirm it validates
- [x] 6.2 Run `kubectl apply --dry-run=server -f .` and confirm all resources validate
- [x] 6.3 Run `openspec validate store-contact-point-url-in-secret --type change --strict`
