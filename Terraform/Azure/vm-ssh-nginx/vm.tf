resource "azurerm_linux_virtual_machine" "example" {
  name                            = "example-vm"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  size                            = "Standard_B1s" # 1CPU, 1GB ram
  admin_username                  = var.vm_admin_user
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Establishes connection to be used by all generic remote provisioners (i.e. file/remote-exec)  
  connection {    
    type     = "ssh"    
    user     = var.vm_admin_user    
    password = var.vm_admin_password    
    host     = self.public_ip_address  
  }

  provisioner "remote-exec" {    
    inline = [      
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
      ]  
    }
}