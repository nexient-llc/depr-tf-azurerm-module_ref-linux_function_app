locals {
  resource_group = {
    location = var.resource_group.location
    name = module.resource_group.resource_group.name
  }

  storage_account = {
    name      = local.storage_account_name
    rg_name   = module.resource_group.resource_group.name
  }

  application_insights = {
    name      = module.app_insights.appins_name
    rg_name   = module.resource_group.resource_group.name
  }

  service_plan = {
    name      = module.service_plan.service_plan_name
    rg_name   = module.resource_group.resource_group.name
  }

  resource_group_name           = module.resource_name["resource_group"].recommended_per_length_restriction
  function_app_name             = module.resource_name["function_app"].recommended_per_length_restriction
  log_analytics_workspace_name  = module.resource_name["log_analytics"].recommended_per_length_restriction
  app_insights_name             = module.resource_name["app_insights"].recommended_per_length_restriction
  service_plan_name             = module.resource_name["service_plan"].recommended_per_length_restriction
  key_vault_name                = module.resource_name["key_vault"].recommended_per_length_restriction
  storage_account_name          = module.resource_name["storage_account"].lower_case

  # Get the corresponding objectIds of all the deployment slots defined in variables
  slots_object_id_map = {
    for name in var.deployment_slots :
      name => module.function_app.function_app_linux_slots["${name}"].identity[0].principal_id
  }

  all_identities_object_id_map = merge({"production" : module.function_app.function_app_identity.principal_id}, local.slots_object_id_map)

  # Key vault Access policies map for all deployment slots
  key_vault_access_policies     = {
    for name, id in local.all_identities_object_id_map:

    "${name}"     => {
      object_id     = id
      tenant_id     = data.azurerm_client_config.current.tenant_id
      key_permissions = []
      certificate_permissions = []
      secret_permissions = ["Get", "Set", "List", "Delete", "Purge"]
      storage_permissions = []

    }
  }
}