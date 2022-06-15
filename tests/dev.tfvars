logical_product_name = "demofunc"
class_env = "dev"
resource_group = {
  location = "eastus"
}

app_insights = {
  application_type = "web"
  custom_tags   = {}
}

log_analytics = {
  sku                                = "PerGB2018"
  retention_in_days                  = 30
  daily_quota_gb                     = 0.5
  custom_tags                     = {}
  internet_ingestion_enabled         = true
  internet_query_enabled             = true
  reservation_capacity_in_gb_per_day = 100
}

service_plan = {
  os_type = "Linux"
  sku_name = "P1v2"
  worker_count = 1
  custom_tags = {}
}

storage_account = {
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = {}
}

# This must exist earlier
container_registry = {
  name = "funcappeastusdev000acr000"
  rg_name = "funcapp-eastus-dev-000-rg-000"
}

docker_image_name = "sample-functions"
docker_image_tag = "1001"

application_stack = "docker"

site_config = {
  "always_on" = true
}

application_settings = {
  "PROVISIONER" = "TERRAFORM"
}

cors = {
  allowed_origins = ["*"]
  support_credentials = false
}

deployment_slots = ["stage"]