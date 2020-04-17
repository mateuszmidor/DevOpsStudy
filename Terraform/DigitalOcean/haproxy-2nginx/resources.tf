variable "do_token" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}

provider "digitalocean" {
  token = var.do_token
}

# loadbalancer
resource "digitalocean_droplet" "web-haproxy" {
  image  = "ubuntu-18-04-x64"
  name   = "web-haproxy"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  private_networking = true # so the loadbalancer can access the two nginx webservers
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
      "apt-get update",
      "apt-get -y install haproxy"
    ]
  }
  provisioner "file" {
    content = data.template_file.haproxyconf.rendered
    destination = "/etc/haproxy/haproxy.cfg"
  }
  provisioner "remote-exec" {
    inline = [
      "service haproxy restart"
    ]
  }
}

# substitute vars inside template file and expose its content = "${data.temlate_file.haproxyconf.rendered}"
data "template_file" "haproxyconf" {
  template = file("${path.module}/haproxy.cfg.tpl")

  vars = {
    web-nginx1_priv_ip = digitalocean_droplet.web-nginx1.ipv4_address_private
    web-nginx2_priv_ip = digitalocean_droplet.web-nginx2.ipv4_address_private
  }
}

# webserver1
resource "digitalocean_droplet" "web-nginx1" {
  image  = "ubuntu-18-04-x64"
  name   = "web-nginx1"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  private_networking = true
  user_data = file("setup_webserver.sh") # will be auto run when droplet is ready
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
}

# webserver2
resource "digitalocean_droplet" "web-nginx2" {
  image  = "ubuntu-18-04-x64"
  name   = "web-nginx2"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  private_networking = true
  user_data = file("setup_webserver.sh") # will be auto run when droplet is ready
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
}

# expose haproxy ip for ease of use
output "loadbalancer_ip_addr" {
  value = digitalocean_droplet.web-haproxy.ipv4_address 
}