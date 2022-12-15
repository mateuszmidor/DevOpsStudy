# echo-server

Intended for Kubernetes, this echo-server will reply with URI, Headers and Body it received on any endpoint.  


## Usage

Run:
```sh
make docker
make start # will run as POD in kubernetes cluster
...
make stop # delete POD from the cluster
```

Send request:
```sh
curl http://echo-server/welcome -d "HelloWorld"  
 
Request: POST /welcome
Headers: map[Accept:[*/*] Content-Length:[10] Content-Type:[application/x-www-form-urlencoded] User-Agent:[curl/7.81.0] X-B3-Parentspanid:[c6791cfddb591ae6] X-B3-Sampled:[1] X-B3-Spanid:[0d3ac01848f0e93f] X-B3-Traceid:[838a776d592b91fac6791cfddb591ae6] X-Envoy-Attempt-Count:[1] X-Forwarded-Client-Cert:[By=spiffe://cluster.local/ns/5gc/sa/default;Hash=28a192c0fed915ea70eaf0ec58ac5e7fd9802e16ba0a2971ac95bd6e1648c45b;Subject="";URI=spiffe://cluster.local/ns/5gc/sa/default] X-Forwarded-Proto:[http] X-Request-Id:[71fb1c07-bc15-9829-9704-2137a01b37fd]]
Body: HelloWorld
```