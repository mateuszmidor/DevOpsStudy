# Envoy WebAssembly filter demonstrating SharedData in golang
 
This example configures Envoy to return canned "Hello!" response, and employs a WASM filter that:
1. increments a counter and prints its value to envoy logs every time the plugin is run

Based on:

1. https://medium.com/trendyol-tech/extending-envoy-proxy-wasm-filter-with-golang-9080017f28ea
1. https://tufin.medium.com/extending-envoy-proxy-with-golang-webassembly-e51202809ba6
1. https://pkg.go.dev/github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm#GetSharedData
1. https://pkg.go.dev/github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm#SetSharedData

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
# send request through Envoy triggering the plugin execution and observe Envoy logs
curl -v localhost:9090
```

```bash
# Envoy logs - "not found" error is expected and not harmful - shared data needs initialization during the plugin's first run
[2022-11-09 11:51:16.521][23][error][wasm] [source/extensions/common/wasm/context.cc:1176] wasm log my_filter my_root_id my_vm_id: proxywasm.GetSharedData error: error status returned by host: not found
[2022-11-09 11:51:16.521][23][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log my_filter my_root_id my_vm_id: Counter value: 1
[2022-11-09 11:51:17.403][24][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log my_filter my_root_id my_vm_id: Counter value: 2
[2022-11-09 11:51:18.071][35][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log my_filter my_root_id my_vm_id: Counter value: 3
```