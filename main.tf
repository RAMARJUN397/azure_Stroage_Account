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

data "azurerm_windows_web_app" "webapp" {
  name                = "tfwebapp"
  resource_group_name = "Terraform_Resource"
}

output "id" {
  value = data.azurerm_windows_web_app.webapp.id
}
