output "resource_group_id" {
  value = azurerm_resource_group.rg1.id
}
# Output the primary access key (marked as sensitive)
output "storage_account_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "storage_account_primary_blob_connection_string" {
  description = "The primary blob connection string for the storage account"
  value       = azurerm_storage_account.storage.primary_blob_connection_string
  sensitive   = true
}