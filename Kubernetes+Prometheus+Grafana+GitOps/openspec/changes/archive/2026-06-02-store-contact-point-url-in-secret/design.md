## Context

`05-contact-point.yaml` currently hardcodes the MS Teams webhook URL as a plaintext string in `receivers[].settings.url`. The webhook URL is a sensitive credential — it grants write access to a Teams channel. This change extracts it into a separate Kubernetes Secret (`contact-point-url`) and references it via the Grafana Operator's `valuesFrom` mechanism (supported since v5.21.0).

This is a purely structural security improvement — no behavioral changes to alert routing.

## Goals / Non-Goals

**Goals:**
- Store the MS Teams webhook URL in a `kind: Secret` YAML, using `stringData` for readability
- Update the GrafanaContactPoint to reference the URL via `valuesFrom[].targetPath: url` with a `secretKeyRef`
- Renumber downstream YAML files so the Secret (05) comes before the contact point (06)

**Non-Goals:**
- No changes to contact point name, Teams integration type, notification policies, or alert rules
- No introduction of Sealed Secrets, External Secrets Operator, or SOPS — plaintext Secret YAML for now
- No changes to Grafana Operator version or CRD schema

## Decisions

1. **Standalone `05-contact-point-url-secret.yaml`** — Separate file makes it explicit and independently manageable. Named `05-` so it sorts before the contact point file (renumbered to `06-`), ensuring the Secret exists at apply time.

2. **`stringData` not `data`** — Values are plaintext (not base64-encoded), improving readability and diff clarity. Kubernetes handles encoding internally.

3. **`secretKeyRef` with key `url`** — The key name matches the `targetPath`, keeping the mapping intuitive.

4. **`settings: {}` in the receiver** — The operator requires a `settings` block to exist; `valuesFrom` injects into it at runtime.

5. **Plaintext Secret for now** — Matches existing project patterns (no encrypted secret tooling in use). Can be upgraded to Sealed Secrets / External Secrets Operator later without changing the contact point YAML.

## Risks / Trade-offs

- [Low] **Validation requires the Secret to exist** — `kubectl apply --dry-run=server` on the contact point will fail if the Secret doesn't already exist. Apply the Secret first, then the contact point.
- [None] **No rollback risk** — The old inline URL approach can be restored by reverting the edits and deleting the Secret.
- [None] **No behavior change** — The Grafana Operator resolves `valuesFrom` at reconciliation time, producing the same contact point configuration.

## Migration Plan

1. Create `05-contact-point-url-secret.yaml` with a placeholder URL (`webhook.site` test endpoint), marked `# REPLACE ME`
2. Edit `05-contact-point.yaml` → rename to `06-contact-point.yaml`, replace `settings.url` with `valuesFrom` referencing `contact-point-url` secret key `url`
3. Rename `06-notification-policy.yaml` → `07-notification-policy.yaml`
4. Rename `07-alert-rule.yaml` → `08-alert-rule.yaml`
5. Update `openspec/specs/grafana-provisioning/spec.md` to mention the webhook URL is sourced from a Kubernetes Secret
6. Apply: `kubectl apply -f 05-contact-point-url-secret.yaml`, then `kubectl apply -f .`
7. Verify the contact point still functions in Grafana UI

## Open Questions

None.
