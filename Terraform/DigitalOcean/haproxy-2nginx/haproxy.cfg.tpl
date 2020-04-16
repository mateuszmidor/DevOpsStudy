defaults
    mode        http
    maxconn     10
    retries     3
    timeout client 3s  # disconnect client if it doesnt talk for 3 sec
    timeout connect 5s # wait 5 sec for connection then give up backend server
    timeout server 3s  # wait 3 sec for response then give up backend server

frontend web-front
    bind :80
    default_backend web-backend

backend web-backend
    server web-nginx1 ${web-nginx1_priv_ip}:80 check
    server web-nginx2 ${web-nginx2_priv_ip}:80 check