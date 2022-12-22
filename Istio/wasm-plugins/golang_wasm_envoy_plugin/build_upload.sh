#!/usr/bin/env bash

set -e

echo "Building plugin binary"
docker run -v "$PWD":/build tinygo/tinygo sh -c "cd /build && tinygo build -o my_plugin.wasm -scheduler=none -target=wasi ./main.go"

echo "Uploading to S3"
aws --profile=rozneg  s3 cp my_plugin.wasm   s3://k8s-envoy-istio-research

echo "Done"