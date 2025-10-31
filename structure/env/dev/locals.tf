locals {
  # resource specific locals
  region                             = "France Central"
  environment                        = "dev"
  vnet_address_space                 = ["10.0.0.0/16"]
  integration_vnet_address_mask      = ["10.0.0.0/24"]
  private_endpoint_vnet_address_mask = ["10.0.1.0/24"]
  subscription_id                    = "0b7cfc6b-1d5f-4517-ba44-b77a232083a1"
}