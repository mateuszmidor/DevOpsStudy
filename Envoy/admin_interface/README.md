# Envoy Admin interface - dynamic configuration
 
 This example configures Envoy admin interface at port 9901

```bash
# run Envoy
docker run -it --rm -v "$PWD"/envoy.yaml:/etc/envoy/envoy.yaml --network host envoyproxy/envoy:v1.22-latest
```

```bash
# send request through Envoy and receive pre-configured response
curl localhost:9090
```

```bash
# dump envoy config
curl localhost:9901/config_dump
```

```bash
# shut down Envoy
curl -X POST localhost:9901/quitquitquit
```