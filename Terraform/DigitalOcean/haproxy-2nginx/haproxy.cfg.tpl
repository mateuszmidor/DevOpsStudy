global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     1024
    user        haproxy
    group       haproxy
    nbproc 4
    daemon

defaults
    mode        http
    log         global
    option      dontlognull
    option      httpclose
    option      httplog
    option      forwardfor
    option      redispatch
    timeout connect 10000 # default 10 second time out if a backend is not found
    timeout client 300000
    timeout server 300000
    maxconn     60000
    retries     3

frontend www-http
    bind :80
    default_backend web-backend

backend web-backend
    server web-nginx1 ${web-nginx1_priv_ip}:80 check
    server web-nginx2 ${web-nginx2_priv_ip}:80 check