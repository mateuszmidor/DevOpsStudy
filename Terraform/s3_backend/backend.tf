# this file can be named anything, not necessarily "backend"
terraform {
  backend "s3" {
    bucket = "terraform-study-s3-bucket" # this bucket must be created beforehand
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}