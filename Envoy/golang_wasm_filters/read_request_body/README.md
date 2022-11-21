# Envoy WebAssembly filter demonstrating HTTP body reading in golang
 
This example configures Envoy to forward requests from localhost:9090 to localhost:8080, and employs a WASM filter that:
1. prints HTTP request's body to envoy logs every time the plugin is run

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
curl -d "My http custom data" localhost:9090
```

Envoy logs:
```text
[2022-11-10 07:29:06.376][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log my_filter my_root_id my_vm_id: BodySize: 19, endOfStream: false
[2022-11-10 07:29:06.376][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log my_filter my_root_id my_vm_id: BodySize: 19, endOfStream: true
[2022-11-10 07:29:06.376][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log my_filter my_root_id my_vm_id: Request body: My http custom data
```