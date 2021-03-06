variable "do_token" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "terraform-study" {
  image  = "ubuntu-18-04-x64"
  name   = "droplet"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
      var.ssh_fingerprint
  ]
}

output "ip" {
  value = digitalocean_droplet.terraform-study.ipv4_address
}