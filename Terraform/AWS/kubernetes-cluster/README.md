# Kubernetes cluster

## Create kubernetes cluster on AWS and print available nodes

Used module:
<https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/11.0.0>

Based on example:
<https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/basic>

## Requirements

Requires configured aws cli:

```bash
pamac build aws-cli
aws configure
```

Requires aws iam authenticator:

```bash
pamac build aws-iam-authenticator-bin
```

## Run

terraform init
terraform apply
terraform output kubectl_config > kubeconfig
KUBECONFIG=kubeconfig kubectl get nodes
terraform destroy
