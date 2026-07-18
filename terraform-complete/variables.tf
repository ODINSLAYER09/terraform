variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "rg-terraform-default"
  type        = string
}

variable "location" {
  description = "Location of the resource"
  default     = "germanywestcentral"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "storage_account_name" {
  description = "Name of the storage account"
}