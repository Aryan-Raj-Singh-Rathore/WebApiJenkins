terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  required_version = ">=1.0.0"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

resource "azurerm_resource_group" "web_rg" {
  name     = "WebServiceRG"
  location = "Central India"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "WebPlan03"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  kind = "Linux"
  reserved = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "RathoreeeWebApp03"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {
    always_on        = true
    linux_fx_version = "DOTNET|8.0" 

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  https_only = true
}
