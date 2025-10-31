terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  backend "azurerm"{
    key = "networking.terraform.tfstate"
    storage_account_name = "sttbasics001"
    resource_group_name = "rg-global"
    container_name       = "tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "0b7cfc6b-1d5f-4517-ba44-b77a232083a1"
}

# Varibales declarations

variable "default_location" {
  type    = string
  default = "France Central"
}

# Resource definition

resource "azurerm_resource_group" "rg-networking-001" {
    name = "rg-networking-001"
    location = var.default_location
}

resource "azurerm_virtual_network" "vnet-networking-001" {
    name = "vnet-networking-001"
    address_space = ["10.0.0.0/16"]
    location =  var.default_location
    resource_group_name = azurerm_resource_group.rg-networking-001.name
}

resource "azurerm_subnet" "snet-networking-001" {
  name = "snet-networking-001"
  address_prefixes = ["10.0.0.0/24"]
  resource_group_name = azurerm_resource_group.rg-networking-001.name
  virtual_network_name = azurerm_virtual_network.vnet-networking-001.name
}

resource "azurerm_storage_account" "st-networking-001" {
    name = "stnetworking002"
    location = var.default_location
    account_tier = "Standard"
    account_replication_type = "LRS"
    resource_group_name = azurerm_resource_group.rg-networking-001.name
}

# Creating private endpoints

# 1 - Setup a private dns for the storage account to be accessible from calling networks (Optional, is implicit with private endpoints, but necessary for private DNS assignment)
resource "azurerm_private_dns_zone" "pdns-link" {
    resource_group_name = azurerm_resource_group.rg-networking-001.name
    name = "privatelink.vnet-networking-001.blob.core.windows.net"
}

# 2 - Bind the private dns to the vnet from which we will have the intgeration (Optional, is implicit with private endpoints, but necessary for prvate dns assignment)

resource "azurerm_private_dns_zone_virtual_network_link" "plink-vnet_networking-001" {
  name = "plink-vnet_networking-001"
  virtual_network_id = azurerm_virtual_network.vnet-networking-001.id
  resource_group_name = azurerm_resource_group.rg-networking-001.name
  private_dns_zone_name = azurerm_private_dns_zone.pdns-link.name
}

# 3 - Create a private endpoint

resource "azurerm_private_endpoint" "pe-networking-vnet001-st001" {
  name = "pe-networking-vnet001-st001"
  resource_group_name = azurerm_resource_group.rg-networking-001.name
  location = var.default_location
  subnet_id = azurerm_subnet.snet-networking-001.id
  private_service_connection {
    is_manual_connection = false
    name = "pconnnetworkingvnet001st001"
    private_connection_resource_id = azurerm_storage_account.st-networking-001.id
    subresource_names              = ["blob"]
  }
}


# Create function app and associate it to vnet so we can test file read from azure function

# We'll implement a vnet integration for the function app
# The function app's subnet will be marked as delegated so it is only used by azure app services server farms
# This is necessary for vnet integration in order for the vnet integration to work (subnet should contain only function apps (can contain mulitple) and should not be on the private endpoint subnet)
resource "azurerm_subnet" "snet-networking-002" {
  name = "snet-networking-002"
  address_prefixes = [ "10.0.1.0/24" ]
  resource_group_name = azurerm_resource_group.rg-networking-001.name
  virtual_network_name = azurerm_virtual_network.vnet-networking-001.name

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [ "Microsoft.Network/virtualNetworks/subnets/action" ]
    }
  }
}

resource "azurerm_storage_account" "st-networking-003" {
  name = "stnetworking003"
  location = var.default_location
  resource_group_name = azurerm_resource_group.rg-networking-001.name
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp-networking-001" {
    name = "asp-networking-001"
    resource_group_name = azurerm_resource_group.rg-networking-001.name
    location = var.default_location
    sku_name = "B1"
    os_type = "Linux"
}

resource "azurerm_linux_function_app" "func-networking-001" {
  name = "func-networking-001"
  resource_group_name = azurerm_resource_group.rg-networking-001.name
  location = var.default_location
  storage_account_name = azurerm_storage_account.st-networking-003.name
  storage_account_access_key = azurerm_storage_account.st-networking-003.primary_access_key
  service_plan_id = azurerm_service_plan.asp-networking-001.id
  site_config {
    always_on = "false"
  }
}

# this is the vnet integration, where we integrate the function app with the service endpoint
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_function_app.func-networking-001.id
  subnet_id = azurerm_subnet.snet-networking-002.id
}
