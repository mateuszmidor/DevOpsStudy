import sys, json

with open('terraform.tfstate') as f:
    state = json.load(f)
    
dns = state['resources'][0]['instances'][0]['attributes']['public_dns']
print(dns)