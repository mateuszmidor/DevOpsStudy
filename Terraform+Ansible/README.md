# Create EC2 instance with Terraform then configure it with Ansible

## Steps

- Provision EC2 instance with terraform
- Extract instance dns from terraform.tfstate into ansible inventory.ini
- Install and run apache2 with ansible

## Required

- AWS CLI (configured to use your AWS account: aws configure)
- AWS key "terraform-key" saved under ~/Downloads/terraform-key.pem. It is referenced in ```resources.tf```  
  <https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#KeyPairs:>  
- Ansible
- Terraform

## Run

```bash
  ./run_all.sh
```
