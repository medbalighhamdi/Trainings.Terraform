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
  subscription_id = local.subscription_id
}

module "global" {
  source          = "../../modules/global"
  region          = local.region
  subscription_id = local.subscription_id
  environment     = local.environment
}

module "storage" {
  source              = "../../modules/storage"
  region              = local.region
  environement        = local.environment
  resource_group_name = module.global.rg_name
  subscription_id     = local.subscription_id
}

module "networking" {
  source                                              = "../../modules/networking"
  environment                                         = local.environment
  region                                              = local.region
  resource_group_name                                 = module.global.rg_name
  vnet_address_space                                  = local.vnet_address_space
  private_endpoint_subnet_address_space               = local.private_endpoint_vnet_address_mask
  private_endpoint_attached_storageaccount_resourceid = module.storage.storge_account_resourceid
  subscription_id                                     = local.subscription_id
}


module "compute" {
  source                    = "../../modules/compute"
  resource_group_name       = module.global.rg_name
  virtual_network_name      = module.networking.vnet_name
  integration_vnet_prefixes = local.integration_vnet_address_mask
  environement              = local.environment
  region                    = local.region
  subscription_id           = local.subscription_id
}
