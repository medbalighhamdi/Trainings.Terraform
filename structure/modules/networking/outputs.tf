#------------------------------------
# Outputs definition
#------------------------------------
output "vnet_name" {
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.vnet-structure-001.name
}