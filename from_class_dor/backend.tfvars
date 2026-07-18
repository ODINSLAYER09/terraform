terraform {
  backend "azurerm" {
    resource_group_name  = "demo-rg"
    storage_account_name = "demotfaccount123400000"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}