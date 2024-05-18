terraform {
  required_version = ">= 1.7.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
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
