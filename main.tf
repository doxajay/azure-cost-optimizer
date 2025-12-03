terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource group just to have a scope
resource "azurerm_resource_group" "rg" {
  name     = "rg-policy-demo"
  location = "canadacentral"
}

# Built-in policy definition - example: "Not allowed resource types"
data "azurerm_policy_definition" "deny_public_ip" {
  display_name = "Not allowed resource types"
}

# ✅ Use the v4-compatible resource for RG-level assignment
resource "azurerm_resource_group_policy_assignment" "deny_public_ip_assignment" {
  name                 = "deny-public-ip-assignment"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id

  description = "Assignment to deny certain resource types in this resource group"
}
