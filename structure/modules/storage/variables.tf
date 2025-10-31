variable "region" {
  type        = string
  description = "The Azure Region"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name holding all the networking components"
}

variable "environement" {
  type        = string
  description = "Environment name. Used for naming the resources."
}

variable "subscription_id" {
  type        = string
  description = "Subscription id"
}