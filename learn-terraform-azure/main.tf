# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
    cloud {
    organization = "cybertrain"
    workspaces {
      name = "learn-terraform-azure"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = "germanywestcentral"

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
    created-on : "2026-07-16T14:45:26.6101856Z"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  tags = {
    created-on : "2026-07-16T14:45:31.4156153Z"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet2" {
  name                = "legacy-vnet"
  address_space       = ["172.16.0.0/24"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  tags = {
    created-on : "2026-07-16T17:39:10.4851975Z"
  }
}


# 1. "Look up" the existing subnet in Azure
resource "azurerm_subnet" "subnet1" {
  name                 = "default"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = azurerm_resource_group.rg1.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "myTFSubnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "test-nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "91.11.237.95/32"
    destination_address_prefix = "*"
  }
  tags = {
          created-on : "2026-07-16T17:41:17.6814355Z"
        }
        
}

resource "azurerm_subnet_network_security_group_association" "test_nsg_assoc" {
  subnet_id                 = resource.azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "test_nsg_assoc2" {
  subnet_id                 = resource.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_storage_account" "storage" {
  name                     = "jamescyberstorage123"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  

  tags = {
    environment = "development"
    created-on : "2026-07-16T14:45:36.4156153Z"
  }
}

