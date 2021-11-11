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

resource "azurerm_service_plan" "example" {
  name                = "example"
  resource_group_name = "Terraform_Resource"
  location            = "East US"
  sku_name            = "P1V2"
}

resource "azurerm_windows_web_app" "example" {
  name                = "example"
  resource_group_name = "Terraform_Resource"
  location            = "East US"
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}
