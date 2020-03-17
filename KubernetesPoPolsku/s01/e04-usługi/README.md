https://www.youtube.com/watch?v=vmLiq5ygpww&list=PLC2hWv6J_iIzt3140dXL-Ts31Owodl7lB&index=4

## Service ypes

- ClusterIP - Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default ServiceType.
- NodePort - Exposes the Service on each Node’s IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created. You’ll be able to contact the NodePort Service, from outside the cluster, by requesting <NodeIP>:<NodePort>
- LoadBalancer - Exposes the Service externally using a cloud provider’s load balancer. NodePort and ClusterIP Services, to which the external load balancer routes, are automatically created.
