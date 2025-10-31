#------------------------------------
# Provider declaration
#------------------------------------

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

#---------------------------
# locals
#---------------------------

locals {
  vnet_name                                   = "vnet-structure-${var.environment}-001"
  pe_subnet_name                              = "snet-structure-${var.environment}-001"
  private_dns_zone_name                       = "privatelink.vnet-structure-${var.environment}-001.blob.core.windows.net"
  private_link_name                           = "plink-vnet_structure-${var.environment}-001"
  private_endpoint_name                       = "pe-structure-${var.environment}-vnet001-st001"
  private_service_connection_name             = "pconnstructure${var.environment}vnet001st001"
  private_service_connection_subresourcenames = ["blob"]
}

#------------------------------------
# resources definition
#------------------------------------

resource "azurerm_virtual_network" "vnet-structure-001" {
  name                = local.vnet_name
  address_space       = var.vnet_address_space
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "snet-structure-001" {
  name                 = local.pe_subnet_name
  address_prefixes     = var.private_endpoint_subnet_address_space
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-structure-001.name
  depends_on = [
    azurerm_virtual_network.vnet-structure-001
  ]
}

# Creating private endpoints

# 1 - Setup a private dns for the storage account to be accessible from calling networks (Optional, is implicit with private endpoints, but necessary for private DNS assignment)
resource "azurerm_private_dns_zone" "pdns-link" {
  resource_group_name = var.resource_group_name
  name                = local.private_dns_zone_name
}

# 2 - Bind the private dns to the vnet from which we will have the intgeration (Optional, is implicit with private endpoints, but necessary for prvate dns assignment)

resource "azurerm_private_dns_zone_virtual_network_link" "plink-vnet_structure-001" {
  name                  = local.private_link_name
  virtual_network_id    = azurerm_virtual_network.vnet-structure-001.id
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pdns-link.name
}

# 3 - Create a private endpoint

resource "azurerm_private_endpoint" "pe-structure-vnet001-st001" {
  name                = local.private_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.region
  subnet_id           = azurerm_subnet.snet-structure-001.id
  private_service_connection {
    is_manual_connection           = false
    name                           = local.private_service_connection_name
    private_connection_resource_id = var.private_endpoint_attached_storageaccount_resourceid
    subresource_names              = local.private_service_connection_subresourcenames
  }
}