import sys, json

with open('terraform.tfstate') as f:
    state = json.load(f)
    
    ip = state['outputs']['loadbalancer_ip_addr']['value']
    print(ip)