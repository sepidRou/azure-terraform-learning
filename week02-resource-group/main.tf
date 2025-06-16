// week02 - create a resource group with Terraform
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

resource "azurerm_resource_group" "rg_week02" {
  name     = "week02ResourceGroup"
  location = "westeurope"
}
