import sys, json

with open('terraform.tfstate') as f:
    state = json.load(f)
    
# get ip of the web-haproxy resource
for res in state['resources']:
    if res['name'] == 'web-haproxy':
        dns = res['instances'][0]['attributes']['ipv4_address']
        print(dns)
        break