# MultusCNI gateway POD example

- create custom-net network
- attach gateway pod to the network (my-intf interface) at gateway's IP and make it forward traffic to eth0
- attach client pod to the network (my-intf interface) and ping google.com over the network

## Run

```sh
kubectl apply -f network-attachment-definition.yaml
kubectl apply -f client_gateway.yaml
kubectl logs client -f
```
output:  

```text
+ ping -I my-intf 216.58.209.4
PING 216.58.209.4 (216.58.209.4) from 192.168.1.44 my-intf: 56(84) bytes of data.
64 bytes from 216.58.209.4: icmp_seq=1 ttl=113 time=44.2 ms
64 bytes from 216.58.209.4: icmp_seq=2 ttl=113 time=45.6 ms
64 bytes from 216.58.209.4: icmp_seq=3 ttl=113 time=41.6 ms
64 bytes from 216.58.209.4: icmp_seq=4 ttl=113 time=47.4 ms
64 bytes from 216.58.209.4: icmp_seq=5 ttl=113 time=47.6 ms
```
