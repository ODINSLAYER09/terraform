# Return the blob storage endpoint URL
# Example: "https://mystorageaccount.blob.core.windows.net/"
# The caller might need this URL to configure other resources
output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

# Return the full Azure resource ID
# Example: "/subscriptions/.../storageAccounts/mystorageaccount"
# Useful for referencing this storage account from other resources
output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage.id
}