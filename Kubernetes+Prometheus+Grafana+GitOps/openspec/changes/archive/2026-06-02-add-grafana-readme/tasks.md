## 1. Create root README

- [x] 1.1 Create `README.md` at repo root with deployment prerequisites (Minikube, kubectl) and two-step deploy instructions (`make` → `make obs`)
- [x] 1.2 Document Grafana admin password retrieval using `kubectl get secret gitops-grafana-admin-credentials -n monitoring -o jsonpath='{.data.GF_SECURITY_ADMIN_PASSWORD}' | base64 -d` and note username is `admin`
- [x] 1.3 Document Grafana UI access via `kubectl port-forward svc/gitops-grafana-service 3000:3000 -n monitoring` and URL `http://localhost:3000`
