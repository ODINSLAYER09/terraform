# ============================================================
# TERRAFORM CONFIGURATION BLOCK
# Specifies which providers and versions this project needs
# ============================================================
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Download from HashiCorp's registry
      version = "~> 4.0"              # Use version 4.x (but not 5.x)
    }
  }
  required_version = ">= 1.9.0"       # Minimum Terraform CLI version
}

# ============================================================
# PROVIDER CONFIGURATION
# Configures how Terraform connects to Azure
# ============================================================
provider "azurerm" {
  features {}  # Required block, even if empty
  # Authentication happens via Azure CLI (az login) - no credentials here
}

# ============================================================
# RESOURCE GROUP
# A container for all Azure resources in this project
# ============================================================
resource "azurerm_resource_group" "rg" {
  name     = "ModulesExerciseRG"
  location = var.location
}

# ============================================================
# REGISTRY MODULE: VIRTUAL NETWORK
# Using a pre-built module from Terraform Registry instead of
# writing all the VNet configuration ourselves
# ============================================================
# Azure Verified Modules (AVM) are official modules maintained by Microsoft
# Find them at: https://registry.terraform.io/namespaces/Azure
module "vnet" {
  # source = "NAMESPACE/MODULE_NAME/PROVIDER"
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.0"  # Always pin the version for reproducibility

  # Module inputs - check the module's documentation for available options
  name          = "ModuleVNet"
  location      = azurerm_resource_group.rg.location  # Reference the RG we created
  parent_id     = azurerm_resource_group.rg.id        # The RG's resource ID
  address_space = ["10.0.0.0/16"]                     # IP range for the VNet

  # Subnets are defined as a map of objects
  subnets = {
    "default" = {
      name             = "default"
      address_prefixes = ["10.0.1.0/24"]  # Subnet IP range (subset of VNet)
    }
  }

  tags = {
    Environment = "Terraform Modules Exercise"
  }
}

# ============================================================
# LOCAL MODULE CALL #1: LOGGING STORAGE
# Using our custom module to create the first storage account
# ============================================================
module "logging_storage" {
  # source = relative path to the module folder
  source = "./modules/storage_account"

  # Pass values to the module's variables
  account_name        = var.logging_storage_name      # From root variable
  location            = var.location                   # From root variable
  resource_group_name = azurerm_resource_group.rg.name # From resource we created
  account_tier        = var.account_tier               # From root variable
}

# ============================================================
# LOCAL MODULE CALL #2: DATA STORAGE
# Same module, different parameters = different storage account
# ============================================================
module "data_storage" {
  source = "./modules/storage_account"

  # Different name, but same location, RG, and tier
  account_name        = var.data_storage_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  account_tier        = var.account_tier
}