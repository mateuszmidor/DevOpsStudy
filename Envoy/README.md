# Envoy proxy

## Tutorials:
- Envoy Fundamentals https://academy.tetrate.io/courses/envoy-fundamentals

## Configuration - `envoy.yaml` structure:
```text
admin
static_resources
	listeners
		- address
		  filter_chains
			- http_connection_manager
			  http_filters
				- router
			  route_config
	clusters
```