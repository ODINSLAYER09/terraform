# Create an Azure Storage Account
# This is the only resource in this module
resource "azurerm_storage_account" "storage" {
  # Use the values passed in through variables
  name                     = var.account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier

  # LRS = Locally Redundant Storage (3 copies in same datacenter)
  # This is the cheapest option - good for dev/test environments
  account_replication_type = "LRS"

  # Tags help you organize and identify resources in Azure Portal
  tags = {
    Environment = "Terraform Modules Exercise"
  }
}