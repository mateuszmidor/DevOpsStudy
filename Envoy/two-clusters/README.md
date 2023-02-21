# ntopng traffic generator for stressing Envoy clusters

Envoy configuration here defines 2 clusters:
- `cluster_asia`, with endpoints luang_prabang and chinag_rai
- `cluster_america`, with endpoints celveland and tucson

luang_prabang and chiang_rai send GET requests `to cluster_america` (to talk to american cities, at random intervals)  
cleveland and tucson send GET requests to `cluster_asia` (to talk to asian cities, at random intervals)

Output:
```sh
luang_prabang_1  | Hello from cleveland
tucson_1         | Hello from chiang_rai
cleveland_1      | Hello from luang_prabang
chiang_rai_1     | Hello from tucson
cleveland_1      | Hello from chiang_rai
chiang_rai_1     | Hello from tucson
luang_prabang_1  | Hello from cleveland
tucson_1         | Hello from luang_prabang
```

## Run it

```sh
docker-compose up
```