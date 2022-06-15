#################################################
#Variables associated with resource naming module
##################################################

variable "logical_product_name" {
  type        = string
  description = "(Required) Name of the application for which the resource is created."
  nullable    = false

  validation {
    condition     = length(trimspace(var.logical_product_name)) <= 15 && length(trimspace(var.logical_product_name)) > 0
    error_message = "Length of the logical product name must be between 1 to 15 characters."
  }
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For ex. dev, qa, uat"
  nullable    = false

  validation {
    condition     = length(trimspace(var.class_env)) <= 15 && length(trimspace(var.class_env)) > 0
    error_message = "Length of the environment must be between 1 to 15 characters."
  }

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 1 to 999."
  }
}


variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 1 to 100."
  }
}

variable "use_region_abbr" {
  description = "Whether to use region abbreviation e.g. eastus -> eus"
  type = bool
  default = true
}

variable "resource_types" {
  description = "Map of cloud resource types to be used in this module"
  type = map(object({
    type = string
    maximum_length = number
  }))
  
  default = {
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
        type           = "fn"
        maximum_length = 59
        }
        "key_vault" = {
        type           = "kv"
        maximum_length = 24
        } 
  }
}

#################################################
#Variables associated with resource group module
##################################################
variable "resource_group" {
  description = "resource group primitive options"
  type = object({
    location = string
  })
  validation {
    condition     = length(regexall("\\b \\b", var.resource_group.location)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

########################################################
# Variables associated with application insights module
########################################################

variable "app_insights" {
  description = "App insights primitive."
  type = object({
    application_type = string
    custom_tags   = map(string)
  })
  default = {
    application_type = "web"
    custom_tags   = {}
  }
}

variable "log_analytics" {
  description = "Log analytics primitive."
  type = object({
    sku                                = string
    retention_in_days                  = number
    daily_quota_gb                     = number
    custom_tags                    = map(string)
    internet_ingestion_enabled         = bool
    internet_query_enabled             = bool
    reservation_capacity_in_gb_per_day = number
  })
  default = {
    sku                                = "PerGB2018"
    retention_in_days                  = 30
    daily_quota_gb                     = 0.5
    custom_tags                     = {}
    internet_ingestion_enabled         = true
    internet_query_enabled             = true
    reservation_capacity_in_gb_per_day = 100
  }
}

########################################################
# Variables associated with service plan module
########################################################

variable "service_plan" {
  description = "Object containing the details for a service plan"
  type = object({
    os_type  = string
    sku_name = string
    custom_tags = map(string)
    worker_count = number
  })
  default = {
    os_type = "Linux"
    sku_name = "P1v2"
    worker_count = 1
    custom_tags = {}
  }
}

########################################################
# Variables associated with storage account module
########################################################

variable "storage_account" {
  description = "storage account config"
  type = object({
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  })
}

variable "storage_containers" {
  description = "map of storage container configs, keyed polymorphically"
  type = map(object({
    name                  = string
    container_access_type = string
  }))
  default  = {}
}

variable "storage_shares" {
  description = "map of storage file shares configs, keyed polymorphically"
  type = map(object({
    name                    = string
    quota                   = number
  }))
  default  = {}
}

########################################################
# Variables associated with linux funcion app module
########################################################

variable "container_registry" {
  description = "The Container Registry associated with the function app. Required only when application_stack = docker"
  type = object ({
      name = string
      rg_name = string
  })
}

variable "application_stack" {
    description = "One of these options - docker, dotnet, java, node, python, powershell, custom"
    default = "docker"
}

variable "docker_image_name" {
    description = "The docker image name. Required only when application_stack = docker"
}

variable "docker_image_tag" {
    description = "The docker image tag. Required only when application_stack = docker"
}

variable "dotnet_version" {
    default = null
    description = "Dotnet version for function runtime. Required only when application_stack = dotnet. Must be 3.1 or 6.0"
}

variable "java_version" {
    default = null
    description = "Dotnet version for function runtime. Required only when application_stack = java"
}

variable "node_version" {
    default = null
    description = "Dotnet version for function runtime. Required only when application_stack = node"
}

variable "python_version" {
    default = null
    description = "Dotnet version for function runtime. Required only when application_stack = python"
}

variable "powershell_version" {
    default = null
    description = "Powershell Core version for function runtime. Required only when application_stack = powershell"
}

variable "use_custom_runtime" {
    default = false
    description = "Is there a custom runtime for the function. Required only when application_stack = custom"
    type = bool
}

variable "site_config" {
    description = "All the site config mentioned in https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app#site_config except application_stack"
    type = any
    default = {}
}

variable "application_settings" {
    description = "The environment variables passed in to the function app"
    type = map(string)
    default = {}
}

variable "connection_strings" {
    description = "List of connection strings (name, type, value)"
    type = list(object({
        name = string
        type = string
        value = string
    }))
    default = []
}

variable "cors" {
    description = "CORS block (allowed_origins, support_credentials)"
    type = object({
        allowed_origins     = list(string)
        support_credentials = bool
    })
    default = null
}

variable "custom_tags" {
    description = "Custom Tags"
    type = map(string)
    default = {}
}

## Variables related to Deployment Slots

variable "deployment_slots" {
  description = "Name of the deployment slots"
  type = list(string)
  default = []
}

########################################################
# Variables associated with key vault module
########################################################

variable "soft_delete_retention_days" {
  description = "Number of retention days for soft delete"
  type = number
  default = 7
}

variable "key_vault_sku" {
  description = "SKU for the key vault - standard or premium"
  type = string
  default = "standard"
}