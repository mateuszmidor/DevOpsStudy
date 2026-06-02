## Why

The Grafana Operator v5.21.0 deprecated the top-level `.spec.type` and `.spec.settings` fields in `GrafanaContactPoint` in favor of the `.spec.receivers[]` array format. The old format is marked as "will be removed in a later version" of the operator. To stay current and avoid breakage on operator upgrades, the existing contact point YAML must be migrated.

## What Changes

- Rewrite `05-contact-point.yaml` to use the new `.spec.receivers[]` format, moving `.spec.type` and `.spec.settings` into a receiver entry under `receivers[]`
- No change in behavior — the MS Teams webhook URL, contact point name, and routing remain identical

## Capabilities

### New Capabilities

None — behavior is unchanged.

### Modified Capabilities

- `grafana-provisioning`: The GrafanaContactPoint CR YAML format is updated from the deprecated single-receiver format to the current `receivers[]` format. No behavior change — the contact point still provisions `type: teams` with the same webhook URL.

## Impact

- Single file changed: `05-contact-point.yaml`
- No API, dependency, or behavior changes
- Compatible with Grafana Operator v5.21.0+
