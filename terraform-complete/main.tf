terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.81.0"
    }

  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.demo-rg.name
  location                 = azurerm_resource_group.demo-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}