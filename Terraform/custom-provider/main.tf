resource "example_server" "my-server" {
    address = "2.3.4.7"
}

output "name" {
  value = example_server.my-server.port
}
