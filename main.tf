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
