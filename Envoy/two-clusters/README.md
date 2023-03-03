# Generate HTTP traffic between two Envoy clusters

This setup uses 8 services in 4 clusters to generate HTTP traffic passing through Envoy Proxy.  

## TL; DR

```
docker-compose up
curl localhost:9901/stats?format=json | jq
```

## Scenario

- there are 4 continents defined: antarctica, europe, america and asia
- there are 2 cities per continent
- each continent has it's response characteristics (latency, error rate, payload size)
- asia talks with america
- europe talks with antarctica


## Configuration

Random latency in [configured](./docker-compose.yml) range is injected in request handling.  
Random HTTP response code in [configured](./docker-compose.yml) proportions is returned (200, 300, 400, 500).  
Random payload of [configured](./docker-compose.yml) size is returned.

## Build

```sh
docker-compose build
```

## Run

```sh
docker-compose up
```

Output:
```sh
luang_prabang_1  | Hello from tucson [payload: 59 bytes]
chiang_rai_1     | Hello from cleveland [payload: 78 bytes]
cleveland_1      | Hello from chiang_rai [payload: 74395 bytes]
tucson_1         | Multiple Choices [payload: 0 bytes]
frosty-colony_1  | Hello from danzig [payload: 1585 bytes]
frozen-camp_1    | Multiple Choices [payload: 0 bytes]
danzig_1         | Hello from frosty-colony [payload: 9 bytes]
cracovia_1       | Hello from frosty-colony [payload: 3 bytes]
...
```

## Get Envoy stats as JSON

```sh
curl localhost:9901/stats?format=json
```

Output: [stats.json](./stats.json)
```json
{
  "stats": [
    ...
    {
      "name": "cluster.cluster_america.upstream_cx_rx_bytes_buffered",
      "value": 0
    },
    {
      "name": "cluster.cluster_america.upstream_cx_rx_bytes_total",
      "value": 22983
    },
    {
      "name": "cluster.cluster_america.upstream_cx_total",
      "value": 120
    },
    {
      "name": "cluster.cluster_america.upstream_cx_tx_bytes_buffered",
      "value": 0
    },
    {
      "name": "cluster.cluster_america.upstream_cx_tx_bytes_total",
      "value": 27960
    },
    ...
    {
      "name": "cluster.cluster_asia.upstream_cx_rx_bytes_buffered",
      "value": 0
    },
    {
      "name": "cluster.cluster_asia.upstream_cx_rx_bytes_total",
      "value": 23654
    },
    {
      "name": "cluster.cluster_asia.upstream_cx_total",
      "value": 121
    },
    {
      "name": "cluster.cluster_asia.upstream_cx_tx_bytes_buffered",
      "value": 0
    },
    {
      "name": "cluster.cluster_asia.upstream_cx_tx_bytes_total",
      "value": 28193
    },    
    ...
```