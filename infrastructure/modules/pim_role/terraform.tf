terraform {
  required_version = ">= 1.7.5"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
}
