## Context

`05-contact-point.yaml` currently uses the deprecated top-level `.spec.type` and `.spec.settings` fields. Grafana Operator v5.21.0 introduced the `.spec.receivers[]` format, and the old top-level fields are marked for removal in a future operator version.

## Goals / Non-Goals

**Goals:**
- Migrate `05-contact-point.yaml` from the deprecated single-receiver format to the current `receivers[]` format
- Preserve all existing behavior: same contact point name, Teams integration type, and webhook URL

**Non-Goals:**
- No changes to notification policies, alert rules, or any other resources
- No changes to the webhook URL or contact point name

## Decisions

1. **Use `receivers[]` array** — per operator docs, each contact point may contain multiple receivers. This change creates a single receiver entry mirroring the existing config.
2. **Keep `spec.name` at top level** — `name` remains a top-level field (it identifies the contact point in Grafana, not the receiver).
3. **No `valuesFrom` needed** — the URL is static and hardcoded, so no secret/configmap references are required.

## Risks / Trade-offs

- [Low] The change requires Grafana Operator v5.21.0+. If the cluster runs an older operator version, the `receivers[]` field will be ignored (unknown field behavior depends on CRD schema). Verify operator version before applying.
- [None] No rollback concern — the old format still works for the duration of v1beta1 support.

## Migration Plan

1. Edit `05-contact-point.yaml`: move `type` and `settings` under a `receivers[0]` entry
2. Apply the updated manifest to the cluster
3. Verify the contact point still works via Grafana UI or by testing an alert

## Open Questions

None.
