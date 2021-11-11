terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "Terraform_Resource" {
  name     = "Terraform_Resource"
  location = "East US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Terraform-Network" {
  name                = "Terraform-Network"
  resource_group_name = "Terraform_Resource"
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_windows_virtual_machine" "Terraform_Console" {
  name                = "Terraform_Console"
  resource_group_name = "Terraform_Resource"
  location            = "East US"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  
}
