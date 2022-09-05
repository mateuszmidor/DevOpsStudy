# Istio addons for telemetry

## Prometheus

Install and run dashboard:
```sh
kubectl apply -f istio-1.14.3/samples/addons/prometheus.yaml
istioctl dashboard prometheus
```
## Grafana (first, install Prometheus)

Install and run dashboard:
```sh
kubectl apply -f istio-1.14.3/samples/addons/grafana.yaml
istioctl dashboard grafana
```

## Zipkin 

Install and run dashboard:
```sh
kubectl apply -f istio-1.14.3/samples/addons/extras/zipkin.yaml
istioctl dashboard zipkin
```

## Kiali

Install and run dashboard:
```sh
kubectl apply -f istio-1.14.3/samples/addons/kiali.yaml
istioctl dashboard kiali
```