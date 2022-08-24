# Envoy Lua filter - inline
 
 This example configures Envoy to listen at 9090 and respond with canned text.  
 It uses Lua filter print add "Begin request" - "End request" logs

```bash
# run Envoy
docker run -it --rm -v "$PWD"/envoy.yaml:/etc/envoy/envoy.yaml --network host envoyproxy/envoy:v1.22-latest
```

```bash
# send request through Envoy and receive pre-configured response. Also see logs from Lua in Envoy process window
curl localhost:9090
```
