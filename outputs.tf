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

output "storage_account" {
    value = module.storage_account.storage_account
    sensitive = true
}