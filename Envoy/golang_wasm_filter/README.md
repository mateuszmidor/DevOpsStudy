# Envoy WebAssembly filter in golang
 
This example configures Envoy to forward requests from localhost:9090 to localhost:8080, and employs a WASM filter that:
1. prints request headers to Envoy log
2. adds custom header `x-wasm-filter` to the reponse. The header value is read from plugin configuration in [envoy.yaml](./envoy.yaml)

Based on:

1. https://medium.com/trendyol-tech/extending-envoy-proxy-wasm-filter-with-golang-9080017f28ea
1. https://tufin.medium.com/extending-envoy-proxy-with-golang-webassembly-e51202809ba6

## Steps

```bash
# build myfilter.wasm binary
docker run -v "$PWD":/build tinygo/tinygo sh -c "cd /build && tinygo build -o myfilter.wasm -scheduler=none -target=wasi ./main.go"
```

```bash
# run Envoy with myfilter.wasm
docker run -it --rm -v "$PWD"/envoy.yaml:/etc/envoy/envoy.yaml -v "$PWD"/myfilter.wasm:/etc/envoy/myfilter.wasm --network host envoyproxy/envoy:v1.22-latest
```

```bash
# listen at localhost:8080 and reply to incoming request
echo -e "HTTP/1.1 200 OK\nContent-Length: 6\n\nWORKS!" | nc -l -p 8080
```

```bash
# send request through Envoy, see request headers logged in Envoy process window and custom header being returned
curl -v localhost:9090
```