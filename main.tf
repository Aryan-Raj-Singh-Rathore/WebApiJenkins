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
  subscription_id = "61bd38d2-51fa-4243-9689-7f55df510fc1"
  tenant_id       = "b0b76d6e-14b7-4c08-8657-a19ef23b3b0b"
  features {}
}

resource "azurerm_resource_group" "web_rg" {
  name     = "WebServiceRG"
  location = "Central India"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "WebPlan03"
  location            = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name

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
    always_on = true
  }
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }

  https_only = true
}
