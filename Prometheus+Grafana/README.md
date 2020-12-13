# Prometheus + Grafana

The metric provider here is simple use of netcat in server mode.  
Prometheus is run with prometheus-config.yaml  
Grafana is run with grafana-datasources.yaml mounted under /etc/grafana/provisioning/datasources  
Grafana default user/pass: admin/admin  

## Metrics source for Prometheus

Prometheus pulls metrics from targets defined in scrape_configs in prometheus-config.yml:
```yaml
scrape_configs:
- job_name: test_target
  honor_timestamps: true
  scrape_interval: 1000ms
  scrape_timeout: 500ms
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - localhost:8080
```

## Metrics format

The metrics are in key-value format:  
```
wave 0.5
```

## Metrics source for Grafana

Grafana pull metrics from Prometheus server defined as datasource in grafana-datasources.yaml:
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    editable: true # configuration of this datasource can be edited in dashboard
```
