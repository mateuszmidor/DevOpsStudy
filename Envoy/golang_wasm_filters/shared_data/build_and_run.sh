#!/usr/bin/env bash

echo "Building WASM filter..."
docker run -v "$PWD":/build tinygo/tinygo sh -c "cd /build && tinygo build -o myfilter.wasm -scheduler=none -target=wasi ./main.go"

echo "Running Envoy..."
docker run -it --rm -v "$PWD"/envoy.yaml:/etc/envoy/envoy.yaml -v "$PWD"/myfilter.wasm:/etc/envoy/myfilter.wasm --network host envoyproxy/envoy:v1.22-latest