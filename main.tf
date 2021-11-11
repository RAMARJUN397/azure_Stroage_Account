
 terraform {
  required_version = ">=0.12.13"
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  object_id =  "361c7985-f47a-4bac-a4ef-51b773ca5197"
  client_secret =  "4983783e-d446-493d-af24-f6c0e0900825"
  subscription_id = "3d133d92-97d4-4100-96d8-3a6e163da246"
  tenant_id =  "14ad6a30-731f-42b0-8013-b85efecc3073"
}

# Create a resource group
resource "azurerm_resource_group" "TResource" {
  name     = "Terraform_Resource"
  location = "East US"
  tags = {
    environment = "TerraformDemo" 
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "TNetwork" {
  name                = "myvnet"
  resource_group_name = azurerm_resource_group.TResource.name
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "TerraformDemo" 
  }
}

#Create SubNet
resource "azurerm_subnet" "terraformsubnet" {
  name                 = "myvnsubnet"
  resource_group_name  = azurerm_resource_group.TResource.name
  virtual_network_name = azurerm_virtual_network.TNetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Create Public Ip 
resource "azurerm_public_ip" "mypublic_Ip" {
  name                = "tpublicip"
  resource_group_name = azurerm_resource_group.TResource.name
  location            = "East US"
  allocation_method   = "Static"

  tags = {
    environment = "TerraformDemo" 
  }
}

#Create Network Security Group
resource "azurerm_network_security_group" "TFNGroup" {
  name                = "TFSecurityGroup1"
  location            = "East US"
  resource_group_name = azurerm_resource_group.TResource.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "TerraformDemo" 
  }
}

#Create network Interface 
resource "azurerm_network_interface" "TFNetworkInter" {
  name                = "TFnic"
  location            = "East US"
  resource_group_name = azurerm_resource_group.TResource.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraformsubnet.id
    private_ip_address_allocation = "Dynamic"
     public_ip_address_id = azurerm_public_ip.mypublic_Ip.id
  }
   tags = {
    environment = "TerraformDemo" 
  }
}

#Create a NSGA
resource "azurerm_subnet_network_security_group_association" "azsnsga" {
  #network_interface_id      = azurerm_network_interface.TFNetworkInter.id
  subnet_id                 =azurerm_subnet.terraformsubnet.id
  network_security_group_id = azurerm_network_security_group.TFNGroup.id
}

#Create Random Id
resource "random_id" "randomid"{
  keepers = {
    resource_group_name = azurerm_resource_group.TResource.name
  }
  byte_length = 8
}

#Create Storage account
resource "azurerm_storage_account" "azstorage" {
  name                     = "tfaccountname"
  resource_group_name      = azurerm_resource_group.TResource.name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "TerraformDemo" 
  }
}
#Create Vms
resource "azurerm_linux_virtual_machine" "Terraform_Console" {
  name                = "myvm"
  resource_group_name = azurerm_resource_group.TResource.name
  network_interface_ids = [azurerm_network_interface.TFNetworkInter.id]
  location            = "East US"
  size                = "Standard_F2"
  os_disk {
     name                = "myoses"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name = "ubuntu"
  admin_username      = "adminuser"
  #disable_password_authentification = false
  admin_password      = "P@$$w0rd1234!"
  boot_diagnostics{
    storage_account_uri = azurerm_storage_account.azstorage.primary_blob_endpoint 
  }
   tags = {
    environment = "TerraformDemo" 
  }
}
