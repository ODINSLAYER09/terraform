# The name of the storage account
# Azure requires storage account names to be globally unique across all Azure
variable "account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
}

# Where to create the storage account (e.g., "germanywestcentral")
variable "location" {
  description = "Azure region for the storage account"
  type        = string
}

# The resource group that will contain this storage account
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Performance tier - Standard uses HDDs (cheaper), Premium uses SSDs (faster)
# Default is "Standard" - if caller doesn't specify, this value is used
variable "account_tier" {
  description = "Performance tier: Standard or Premium"
  type        = string
  default     = "Standard"
}