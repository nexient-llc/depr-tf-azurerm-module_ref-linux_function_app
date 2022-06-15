data "azurerm_client_config" "current" {
}

module "resource_name" {
  source    = "git::git@github.com:nexient-llc/tf-module-resource_name.git?ref=main"

  for_each = var.resource_types

  logical_product_name    = var.logical_product_name
  region                  = var.resource_group.location
  class_env               = var.class_env
  cloud_resource_type     = each.value.type
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.maximum_length
  use_azure_region_abbr   = var.use_azure_region_abbr
}

module "resource_group" {
  source = "git::git@github.com:nexient-llc/tf-azurerm-module-resource_group.git?ref=main"

  resource_group      = var.resource_group
  resource_group_name = local.resource_group_name
  
}

module "app_insights" {
  source = "git::git@github.com:nexient-llc/tf-azurerm-module-app_insights.git?ref=main"

  resource_group                = local.resource_group
  app_insights                  = var.app_insights
  app_insights_name             = local.app_insights_name
  log_analytics                 = var.log_analytics
  log_analytics_workspace_name  = local.log_analytics_workspace_name

  
}

module "service_plan" {
  source = "git::git@github.com:nexient-llc/tf-azurerm-module-service_plan.git?ref=main"

  resource_group                = local.resource_group
  service_plan                  = var.service_plan
  service_plan_name             = local.service_plan_name
}

module "storage_account" {
  source = "git::git@github.com:nexient-llc/tf-azurerm-module-storage_account.git?ref=main"

  resource_group                = local.resource_group
  storage_account_name          = local.storage_account_name
  storage_account               = var.storage_account
  storage_containers            = var.storage_containers
  storage_shares                = var.storage_shares
}

module "function_app" {
  source = "git::git@github.com:nexient-llc/tf-azurerm-module-linux_function_app.git?ref=main"

  resource_group                = local.resource_group
  storage_account               = local.storage_account
  application_insights          = local.application_insights
  service_plan                  = local.service_plan
  container_registry            = var.container_registry
  function_app_name             = local.function_app_name
  application_stack             = var.application_stack
  docker_image_name             = var.docker_image_name
  docker_image_tag              = var.docker_image_tag
  dotnet_version                = var.dotnet_version
  java_version                  = var.java_version
  node_version                  = var.node_version
  python_version                = var.python_version
  powershell_version            = var.powershell_version
  use_custom_runtime            = var.use_custom_runtime
  application_settings          = var.application_settings
  connection_strings            = var.connection_strings
  cors                          = var.cors
  deployment_slots              = var.deployment_slots
  custom_tags                   = var.custom_tags

  depends_on = [module.service_plan.service_plan_name, module.storage_account.storage_account, module.service_plan.service_plan_name, module.app_insights.appins_name]
}

module "key_vault" {
  source = "git::git@github.com:nexient-llc/tf-azurerm-module-key_vault.git?ref=main"

  resource_group                = local.resource_group
  key_vault_name                = local.key_vault_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  sku_name                      = var.key_vault_sku
  access_policies               = local.key_vault_access_policies
  custom_tags                   = var.custom_tags
}