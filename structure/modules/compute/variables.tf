variable "environement" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type        = string
  description = "The Azure region"
}

variable "integration_vnet_prefixes" {
  type        = list(string)
  description = "address space for the integration vnet"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "virtual_network_name" {
  type        = string
  description = "Vnet for integration vnet to be integrated on."
}

variable "subscription_id" {
  type        = string
  description = "Subscription id"
}