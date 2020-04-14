# this file can be named anything, not necessarily "backend"
terraform {
  backend "s3" {
    bucket = "terraform-study-s3-bucket" # this bucket must be created beforehand. In this example it is created by run_all.sh
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}