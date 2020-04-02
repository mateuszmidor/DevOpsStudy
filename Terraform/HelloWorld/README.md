# HelloWorld for Terraform

<https://www.youtube.com/watch?v=RA1mNClGYJ4>

## Finding AMI (Amazon Machine Image)

<https://cloud-images.ubuntu.com/locator/ec2/>

## Steps

```bash
  terraform init
  terraform plan    # dry run, see what changes would be applied to aws
  terraform apply   # crate resources
  terraform destroy # remove all the resources created before
```

Notice: as no kepair is added, no ssh into this instance is possible
