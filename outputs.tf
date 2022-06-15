output "resource_group_name" {
    value = local.resource_group_name
}

output "storage_account_name" {
    value = local.storage_account_name
}

output "function_app_id" {
    value = module.function_app.function_app_id
}

output "function_app_name" {
    value = module.function_app.function_app_name
}

output "function_app_identity" {
    value = module.function_app.function_app_identity
}

output "storage_account" {
    value = module.storage_account.storage_account
    sensitive = true
}

output "key_vault_id" {
    value = module.key_vault.key_vault_id
}

output "key_vault_uri" {
	value = module.key_vault.vault_uri
}

output "function_app_linux_slots" {
    value = module.function_app.function_app_linux_slots
    sensitive = true
}

output "key_vault_access_policies" {
    value = module.key_vault.access_policies_object_ids
    sensitive = true
}