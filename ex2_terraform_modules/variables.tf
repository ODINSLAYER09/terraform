# Azure region where all resources will be created
# Default is Germany West Central - change if needed
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "germanywestcentral"
}

# Performance tier for storage accounts
# This value will be passed to both storage modules
variable "account_tier" {
  description = "Storage account tier: Standard or Premium"
  type        = string
  default     = "Standard"
}

# Name for the first storage account (logging)
# No default - must be provided when running terraform apply
variable "logging_storage_name" {
  description = "Name for the logging storage account"
  type        = string
}

# Name for the second storage account (data)
# No default - must be provided when running terraform apply
variable "data_storage_name" {
  description = "Name for the data storage account"
  type        = string
}