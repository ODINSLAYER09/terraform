# Output the VNet's resource ID from the Registry module
# module.vnet.resource_id refers to the output defined IN the registry module
output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.vnet.resource_id
}

# Output from our first local module call
# module.logging_storage.primary_blob_endpoint refers to the output
# we defined in modules/storage_account/outputs.tf
output "logging_blob_endpoint" {
  description = "Primary blob endpoint for logging storage"
  value       = module.logging_storage.primary_blob_endpoint
}

# Output from our second local module call
output "data_blob_endpoint" {
  description = "Primary blob endpoint for data storage"
  value       = module.data_storage.primary_blob_endpoint
}