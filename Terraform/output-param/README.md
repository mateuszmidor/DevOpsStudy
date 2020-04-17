# Expose specific value in terraform.tfstate "outputs" section

## resources.tf

```json
output "instance_ip_addr" {
  value = "172.9.12.1"
}
```

## terraform.tfstate

```json
{
  "version": 4,
  "terraform_version": "0.12.24",
  "serial": 2,
  "lineage": "18f1ffcc-f53b-b6f7-17fc-b394c3492a1b",
  "outputs": {
    "instance_ip_addr": {
      "value": "172.9.12.1",
      "type": "string"
    }
  },
  "resources": []
}
```
