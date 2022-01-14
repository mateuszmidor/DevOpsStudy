output "public_ip" {
  value = azurerm_linux_virtual_machine.example.public_ip_address
}

output "user_name" {
  value = var.vm_admin_user
}

output "user_password" {
  value = var.vm_admin_password
}