provider "aws" {
  region     = "eu-central-1" # frankfurt

  # the below keys are needed if you dont have aws cli configured ("aws configure")
  # access_key = "ACCESS_KEY_HERE"
  # secret_key = "SECRET_KEY_HERE"
}


resource "aws_instance" "terraform-study" {
  # AMI found on https://cloud-images.ubuntu.com/locator/ec2/
  ami           = "ami-0b6f46ba4d94838a0" # eu-central-1	bionic	18.04 LTS	amd64	hvm:ebs-ssd	20200323	ami-0b6f46ba4d94838a0	hvm
  instance_type = "t2.micro"
}