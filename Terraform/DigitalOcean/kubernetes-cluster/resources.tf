variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "my-kubernetes-cluster" {
  name    = "my-kubernetes-cluster"
  region  = "fra1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "latest"
  tags    = ["staging"]

  node_pool {
    name       = "my-worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}