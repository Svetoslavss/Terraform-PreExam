terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.validation_id
}

resource "random_integer" "random" {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "arg" {
  name     = var.resource_group
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.service_plan}${random_integer.random.result}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "lwaap" {
  name                = "${var.linux_web_app}${random_integer.random.result}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    value = "Data Source=tcp:${azurerm_mssql_server.azsql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.appdb.name};User ID=${azurerm_mssql_server.azsql.administrator_login};Password=${azurerm_mssql_server.azsql.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
    type  = "SQLAzure"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_mssql_server" "azsql" {
  name                         = "${var.mssql_server}${random_integer.random.result}"
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group
  version                      = "12.0"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "appdb" {
  name                 = "${var.mssql_database}${random_integer.random.result}"
  server_id            = azurerm_mssql_server.azsql.id
  license_type         = "LicenseIncluded"
  max_size_gb          = 2
  geo_backup_enabled   = false
  storage_account_type = "Zone"
  zone_redundant       = false
}

resource "azurerm_mssql_firewall_rule" "example" {
  name             = "${var.mssql_firewall_rule}${random_integer.random.result}"
  server_id        = azurerm_mssql_server.azsql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.lwaap.id
  repo_url               = var.git_URL
  branch                 = var.repo_branch
  use_manual_integration = true
}