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
resource "azurerm_virtual_network" "TNetwork" {
  name                = "TNetwork"
  resource_group_name = "Terraform_Resource"
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "tsubnet" {
  name                 = "tsubnet"
  resource_group_name  = "Terraform_Resource"
  virtual_network_name = "TNetwork" 
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = "East US"
  resource_group_name = "Terraform_Resource"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "tsubnet"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "Terraform_Console" {
  name                = "Terraform_Console"
  resource_group_name = "Terraform_Resource"
  location            = "East US"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
