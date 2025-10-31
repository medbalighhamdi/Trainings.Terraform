terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}


locals {
  azf_integration_vnet_name = "snet-structure-${var.environement}-002"
  azf_name                  = "func-structure-${var.environement}-001"
  azf_storage_account_name  = "ststructure${var.environement}003"
  azf_service_plan_name     = "asp-structure-${var.environement}-001"
}

# We'll implement a vnet integration for the function app
# The function app's subnet will be marked as delegated so it is only used by azure app services server farms
# This is necessary for vnet integration in order for the vnet integration to work (subnet should contain only function apps (can contain mulitple) and should not be on the private endpoint subnet)
resource "azurerm_subnet" "snet-structure-002" {
  name                 = local.azf_integration_vnet_name
  address_prefixes     = var.integration_vnet_prefixes
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  # necessary in order to setup the vnet to be solely dedicated to integration
  # going forward this config, this subnet will not manage other workloads than serverFarms which are related to compute resources like app services and function apps
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_storage_account" "st-structure-003" {
  name                     = local.azf_storage_account_name
  location                 = var.region
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp-structure-001" {
  name                = local.azf_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.region
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_function_app" "func-structure-001" {
  name                       = local.azf_name
  resource_group_name        = var.resource_group_name
  location                   = var.region
  storage_account_name       = azurerm_storage_account.st-structure-003.name
  storage_account_access_key = azurerm_storage_account.st-structure-003.primary_access_key
  service_plan_id            = azurerm_service_plan.asp-structure-001.id
  site_config {
    always_on = "false"
  }
}

# this is the vnet integration, where we integrate the function app with the service endpoint
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_function_app.func-structure-001.id
  subnet_id      = azurerm_subnet.snet-structure-002.id
}
