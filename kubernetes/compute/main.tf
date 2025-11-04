terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  backend "azurerm" {
    key                  = "structure.terraform.tfstate"
    storage_account_name = "sttbasics001"
    resource_group_name  = "rg-global"
    container_name       = "tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription
}


resource "azurerm_kubernetes_cluster" "aks-kubernetes-001" {
  name                = "aks-${var.environment}-001"
  location            = var.region
  resource_group_name = var.resource_group_name
  default_node_pool {
    name    = "npkube001"
    vm_size = "standard_a2_v2"
    node_count = 1
  }
  dns_prefix = "kubernetes"
  identity {
    type = "SystemAssigned"
  }
}
