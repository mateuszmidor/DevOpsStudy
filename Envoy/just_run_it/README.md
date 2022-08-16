# Envoy minimal working example - localhost port forwarding
 
 This example configures Envoy to forward requests from localhost:9090 to localhost:8080

```bash
# run Envoy
docker run -it --rm -v "$PWD"/envoy.yaml:/etc/envoy/envoy.yaml --network host envoyproxy/envoy:v1.22-latest
```

```bash
# listen at localhost:8080 and reply to incoming request
echo -e "HTTP/1.1 200 OK\nContent-Length: 6\n\nWORKS!" | nc -l -p 8080
```

```bash
# send request through Envoy
curl localhost:9090
```