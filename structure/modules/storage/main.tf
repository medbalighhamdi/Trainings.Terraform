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
  storage_account_name = "ststructure${var.environement}002"
}

resource "azurerm_storage_account" "st-structure-001" {
  name                     = local.storage_account_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = var.resource_group_name
}