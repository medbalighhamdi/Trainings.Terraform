# ---------------------------------
# Varibales and locals declarations
#----------------------------------

variable "region" {
  type        = string
  description = "The Azure Region"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name holding all the networking components"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "name of the vnet space"
}

variable "private_endpoint_subnet_address_space" {
  type        = list(string)
  description = "private endpoint subnet address space"
}

variable "environment" {
  type        = string
  description = "environement name that is used in naming resources"
}


variable "private_endpoint_attached_storageaccount_resourceid" {
  type        = string
  description = "The private endpoint will permit connection to the provided storage account in this variable"
}

variable "subscription_id" {
  type        = string
  description = "Subscription id"
}