# This configuration intentionally violates our security policies!
# 1. No tags defined (violates tagging policy)
# 2. Public network access enabled (violates security policy)

# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 4.0"
#     }
#   }
#   required_version = ">= 1.9.0"
# }

# provider "azurerm" {
#   features {}
# }

# # Create a resource group (also missing required tags!)
# resource "azurerm_resource_group" "rg" {
#   name     = "ComplianceTestRG"
#   location = "germanywestcentral"
#   # VIOLATION: No tags defined!
  
# }

# # Create a storage account with insecure settings
# resource "azurerm_storage_account" "storage" {
#   name                     = "cyberjcomptest123777"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   # VIOLATION: Public access is enabled!
#   public_network_access_enabled = true

#   # VIOLATION: No tags defined!
# }

# COMPLIANT configuration - all policies satisfied

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "azurerm" {
  features {}
}

# Create a resource group with required tags
resource "azurerm_resource_group" "rg" {
  name     = "ComplianceTestRG"
  location = "germanywestcentral"

  # FIX: Added required Department tag
  tags = {
    Department = "Engineering"
  }
}

# Create a storage account with secure settings
resource "azurerm_storage_account" "storage" {
  name                     = "yourinitialscomptest123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # FIX: Public access is now disabled
  public_network_access_enabled = false

  # FIX: Added required Department tag
  tags = {
    Department = "Engineering"
  }
}