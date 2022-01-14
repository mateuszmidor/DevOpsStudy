variable "location" {
  type = string
  default = "eastus"
  description = "Azure location"
}

variable "vm_admin_user" {
  type = string
  default = "admin123"
  description = "VM admin name"
}

variable "vm_admin_password" {
  # The supplied password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements:
  # - Contains an uppercase character
  # - Contains a lowercase character
  # - Contains a numeric digit
  # - Contains a special character
  # Control characters are not allowed
  type = string
  default = "Admin123"
  description = "VM admin password"
}