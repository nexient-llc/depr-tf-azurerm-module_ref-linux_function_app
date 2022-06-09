locals {
    resource_types = {
        "resource_group" = {
        type           = "rg"
        maximum_length = 63
        }
        "app_insights" = {
        type           = "appins"
        maximum_length = 260
        }
        "service_plan" = {
        type           = "plan"
        maximum_length = 60
        }
        "log_analytics" = {
        type           = "log"
        maximum_length = 63
        }
        "storage_account" = {
        type           = "sa"
        maximum_length = 24
        }
        "function_app" = {
        type           = "func"
        maximum_length = 59
        }
    }

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
  storage_account_name          = module.resource_name["storage_account"].lower_case
}