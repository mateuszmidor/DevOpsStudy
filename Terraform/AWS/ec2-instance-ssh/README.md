# HelloWorld with SSH for Terraform

<https://www.youtube.com/watch?v=luQ8Fds-EQU>

## Finding AMI (Amazon Machine Image)

<https://cloud-images.ubuntu.com/locator/ec2/>

## Steps

  First, create in AWS and download an EC2 keypair named: terraform-key.pem into ~/Downloads. Set permissions to 600. It is referenced in ```resources.tf```  
  <https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#KeyPairs:>  
  Then:

```bash
  ./run_all.sh
```
