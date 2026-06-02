## Why

The repository has no root README.md, making it difficult for new users to understand how to access Grafana or retrieve admin credentials after deployment. This creates friction for anyone trying to verify or use the monitoring stack.

## What Changes

- Add a root `README.md` that documents:
  - How to deploy the monitoring stack (reference to `make` and `make obs`)
  - How to retrieve the auto-generated Grafana admin password
  - How to access the Grafana UI via `kubectl port-forward`
  - The Grafana UI URL (`http://localhost:3000`)
  - Username (`admin`) for login

## Capabilities

### New Capabilities

- `grafana-access-guide`: Root README documenting post-deployment Grafana access steps — credentials retrieval, port-forward setup, and UI URL.

### Modified Capabilities

*(None)*

## Impact

- Single new file: `README.md` at repository root.
- No changes to existing manifests, Helm charts, or deployment workflows.
