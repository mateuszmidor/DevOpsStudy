# Kubernetes + Prometheus + Grafana for cluster monitoring

This setup is pretty easy and provides pretty cool dashboards!

## Install Prometheus Operator with embedded Grafana using Helm chart

https://medium.com/@sushantkapare1717/setup-prometheus-monitoring-on-kubernetes-using-grafana-fe09cb3656f7

**Note:** for operator helm chart, use: `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`

## Access Grafana

```sh
kubectl port-forward -n prometheus svc/stable-grafana 8000:80
firefox localhost:8000
```

Grafana credentials:
* user: admin
* pass: prom-operator

## Simple CPU-load generator, 3000m CPU:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: load-generator
  name: load-generator
spec:
  replicas: 3
  selector:
    matchLabels:
      app: load-generator
  template:
    metadata:
      labels:
        app: load-generator
    spec:
      containers:
      - command:
        - sh
        - -c
        - dd if=/dev/random of=/dev/null
        image: alpine
        name: alpine
        resources:
          requests:
            cpu: 50m
          limits:
            memory: 100Mi
```

