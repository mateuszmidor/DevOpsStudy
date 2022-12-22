# Istio debugging

Based on https://academy.tetrate.io/courses/take/istio-fundamentals/lessons/19068914-7-3-debugging-checklist

## Commands

- `istioctl validate -f customers.yaml` - validate the yaml for indentation, arrays notation etc
- `istioctl analyze` - validate the configuration is valid, eg. missing resources that are referenced by other resources
- `istioctl x describe service web-frontend`
    ```sh
    Service: web-frontend
    Port: http 80/HTTP targets pod port 8080


    Exposed on Ingress Gateway http://10.98.23.63
    VirtualService: web-frontend
    1 HTTP route(s)
    ```
- `istioctl x describe pod web-frontend-74dd5cbcdc-rzlpb` - print configuration related to pod-service-gateway
    ```sh
    Pod: web-frontend-74dd5cbcdc-rzlpb
    Pod Revision: default
    Pod Ports: 8080 (web), 15090 (istio-proxy)
    --------------------
    Service: web-frontend
    Port: http 80/HTTP targets pod port 8080
    --------------------
    Effective PeerAuthentication:
    Workload mTLS mode: PERMISSIVE


    Exposed on Ingress Gateway http://10.98.23.63
    VirtualService: web-frontend
    1 HTTP route(s)
    ```
- `istioctl proxy-status` - did Envoy Proxy receive and accept the config? If not, we may need to check istio pilot logs
    ```sh
    NAME                                                   CLUSTER        CDS        LDS        EDS        RDS          ECDS         ISTIOD                      VERSION
    customers-v1-75d7677d5-lx7hg.default                   Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED       NOT SENT     istiod-84d979766b-5vnbg     1.14.3
    istio-egressgateway-58949b7c84-7vz89.istio-system      Kubernetes     SYNCED     SYNCED     SYNCED     NOT SENT     NOT SENT     istiod-84d979766b-5vnbg     1.14.3
    istio-ingressgateway-75bc568988-ztrcn.istio-system     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED       NOT SENT     istiod-84d979766b-5vnbg     1.14.3
    web-frontend-74dd5cbcdc-rzlpb.default                  Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED       NOT SENT     istiod-84d979766b-5vnbg     1.14.3
    ```
    , all should be SYNCED. STALE means network problems or need to scale the istio pilot

- `istioctl proxy-config route web-frontend-74dd5cbcdc-rzlpb` - display routes configured for POD
    ```sh
    NAME                                                                      DOMAINS                                                      MATCH                  VIRTUAL SERVICE
    80                                                                        customers, customers.default + 1 more...                     /*                     customers.default
    80                                                                        istio-egressgateway.istio-system, 10.105.253.189             /*                     
    80                                                                        istio-ingressgateway.istio-system, 10.98.23.63               /*                     
    80                                                                        kubernetes-dashboard.kubernetes-dashboard, 10.110.229.78     /*                     
    80                                                                        tracing.istio-system, 10.102.1.105                           /*                     
    80                                                                        web-frontend, web-frontend.default + 1 more...               /*                     
    8383                                                                      istio-operator.istio-operator, 10.105.76.154                 /*                     
    9090                                                                      kiali.istio-system, 10.108.134.148                           /*                     
    9090                                                                      prometheus.istio-system, 10.106.61.49                        /*                     
    9411                                                                      zipkin.istio-system, 10.102.161.165                          /*                     
    15010                                                                     istiod.istio-system, 10.96.163.202                           /*                     
    InboundPassthroughClusterIpv4                                             *                                                            /*                     
    grafana.istio-system.svc.cluster.local:3000                               *                                                            /*                     
    dashboard-metrics-scraper.kubernetes-dashboard.svc.cluster.local:8000     *                                                            /*                     
    istio-ingressgateway.istio-system.svc.cluster.local:15021                 *                                                            /*                     
    kubernetes-dashboard.kubernetes-dashboard.svc.cluster.local:80            *                                                            /*                     
    inbound|8080||                                                            *                                                            /*                     
    kube-dns.kube-system.svc.cluster.local:9153                               *                                                            /*                     
                                                                              *                                                            /healthz/ready*        
    InboundPassthroughClusterIpv4                                             *                                                            /*                     
                                                                              *                                                            /stats/prometheus*     
    15014                                                                     istiod.istio-system, 10.96.163.202                           /*                     
    20001                                                                     kiali.istio-system, 10.108.134.148                           /*                     
    inbound|8080||                                                            *                                                            /*  
    ```
    Other `istioctl proxy-config` commands related to pods:
    ```text
    all            
    bootstrap      
    cluster        
    endpoint       
    listener       
    log            
    rootca-compare 
    route          
    secret         
    ```

## Logs
- `istiod` logs
- `pilot` logs