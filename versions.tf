terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.31"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.11.0"
    }

  }
}
