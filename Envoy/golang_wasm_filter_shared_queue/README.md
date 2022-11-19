# Envoy WebAssembly filter demonstrating SharedQueue in golang
 
This example configures Envoy to return canned "Hello!" response, and employs 2 WASM filters sharing `my_vm_id`, that:
1. increment a counter and print its value to envoy logs every time the plugin is run

Based on:

1. https://github.com/tetratelabs/proxy-wasm-go-sdk/blob/main/doc/OVERVIEW.md#shared-queue
1. https://medium.com/trendyol-tech/extending-envoy-proxy-wasm-filter-with-golang-9080017f28ea
1. https://tufin.medium.com/extending-envoy-proxy-with-golang-webassembly-e51202809ba6
1. https://pkg.go.dev/github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm#EnqueueSharedQueue
1. https://pkg.go.dev/github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm#DequeueSharedQueue

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

Logs:
```log
[2022-11-15 12:35:36.076][1][info][main] [source/server/server.cc:882] starting main dispatch loop
[2022-11-15 12:35:38.689][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_1 my_root_id my_vm_id: Registering new SharedQueue: "my_queue"
[2022-11-15 12:35:38.689][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_1 my_root_id my_vm_id: Counter value: 1
[2022-11-15 12:35:38.689][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_2 my_root_id my_vm_id: Counter value: 2
[2022-11-15 12:35:39.415][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_1 my_root_id my_vm_id: Counter value: 3
[2022-11-15 12:35:39.415][28][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_2 my_root_id my_vm_id: Counter value: 4
[2022-11-15 12:35:40.071][32][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_1 my_root_id my_vm_id: Counter value: 5
[2022-11-15 12:35:40.071][32][info][wasm] [source/extensions/common/wasm/context.cc:1170] wasm log incrementer_filter_2 my_root_id my_vm_id: Counter value: 6
```