// week06 - Attach NSG to a subnet, allow port 80 (HTTP)

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_week06" {
  name     = "week06ResourceGroup"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "week06-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_week06.location
  resource_group_name = azurerm_resource_group.rg_week06.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "week06-subnet"
  resource_group_name  = azurerm_resource_group.rg_week06.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "week06-nsg"
  location            = azurerm_resource_group.rg_week06.location
  resource_group_name = azurerm_resource_group.rg_week06.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_week06.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
