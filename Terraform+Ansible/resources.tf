provider "aws" {
  region     = "eu-central-1" # frankfurt

  # the below keys are needed if you dont have aws cli configured ("aws configure")
  # access_key = "ACCESS_KEY_HERE"
  # secret_key = "SECRET_KEY_HERE"
}

resource "aws_instance" "ec2-web-server" {
  # AMI found on https://cloud-images.ubuntu.com/locator/ec2/
  ami           = "ami-0b6f46ba4d94838a0" # eu-central-1	bionic	18.04 LTS	amd64	hvm:ebs-ssd	20200323	ami-0b6f46ba4d94838a0	hvm
  instance_type = "t2.micro"
  key_name = "terraform-key" # just the AWS keypair name, not a downloaded file name
  security_groups = ["${aws_security_group.allow_ssh.name}", "${aws_security_group.allow_http.name}"]
}

# need sercurity group with ssh allowed; by default all traffic is disallowed
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol =   "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http traffic"

  # for accessing http server
  ingress {
    from_port   = 80
    to_port     = 80
    protocol =   "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  # for apt-get
  egress {
    from_port   = 80
    to_port     = 80
    protocol =   "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
}

output "dns" {
  value = aws_instance.ec2-web-server.public_dns
}