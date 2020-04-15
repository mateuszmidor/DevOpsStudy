variable "do_token" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "terraform-study" {
  image  = "ubuntu-18-04-x64"
  name   = "droplet-nginx"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
      var.ssh_fingerprint
  ]
  connection {
    user = "root"
    type = "ssh"
    host = self.ipv4_address 
    private_key = file(var.pvt_key) # to authorize ssh login to instance
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
    ]
  }
}