terraform {
  required_providers {
     azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-global"
    storage_account_name = "sttbasics001"
    container_name       = "tfstate"
    key                  = "basics.terraform.tfstate"
  }
  required_version = "~> 1.13.0"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "0b7cfc6b-1d5f-4517-ba44-b77a232083a1"
}

variable "resources_location" {
  type = string
  default = "France Central"
}

resource "azurerm_resource_group" "rg1" {
  name     = "rg-tbasics-001"
  location = var.resources_location
}

resource "azurerm_virtual_network" "vnet-tbasics-001" {
    name = "vnet-tbasics-001"
    address_space = ["10.0.0.0/16"]
    location = var.resources_location
    resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "snet-tbasics-001" {
    name = "snet-tbasics-001"
    resource_group_name = azurerm_resource_group.rg1.name
    virtual_network_name = azurerm_virtual_network.vnet-tbasics-001.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "nic1" {
    name = "nic-tbasics-001"
    resource_group_name = azurerm_resource_group.rg1.name
    location = var.resources_location
    ip_configuration {
      name = "ipconfig1"
      private_ip_address = "10.0.0.10"
      private_ip_address_allocation = "Static"
      subnet_id = azurerm_subnet.snet-tbasics-001.id
    }
}

resource "azurerm_virtual_machine" "vm1" {
    name = "vm-tbasics-001"
    resource_group_name = azurerm_resource_group.rg1.name
    location = var.resources_location
    network_interface_ids = [azurerm_network_interface.nic1.id]
    vm_size = "Standard_DS1_v2"
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "osdisk-tbasics-001"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm-tbasics-001"
        admin_username = "azureuser"
        admin_password = "StrongP@ssword123!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
}