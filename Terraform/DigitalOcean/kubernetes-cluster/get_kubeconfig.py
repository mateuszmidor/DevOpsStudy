import sys, json

with open('terraform.tfstate') as f:
    state = json.load(f)
    
raw_config = state['resources'][0]['instances'][0]['attributes']['kube_config'][0]['raw_config']
print(raw_config)