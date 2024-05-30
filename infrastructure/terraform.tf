terraform {
  required_version = ">= 1.7.5"
  required_providers {

    # Locking azurerm to a version here as the PIM APIs 
    # and resources have been buggy and required changes
    # in the past
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.103"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
  # backend "azurerm" {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}
