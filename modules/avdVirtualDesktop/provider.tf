terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.46.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = "e35cc99a-db1c-49dc-ac4a-ab0b25f59f63"
  client_secret   = "t_N8Q~S8P~.PvWccbKcP2-9aExLXyYo9ulZ-ybNC"
  tenant_id = "4f02b584-f3fb-4aa8-ad45-151db3b6a408"
  subscription_id = "1a317aed-2ae0-467e-a97d-46ea4e51f919"
}
