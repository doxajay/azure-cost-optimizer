terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # recent provider that supports policy_assignment
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

# Example: built-in policy definition - deny public IPs
data "azurerm_policy_definition" "deny_public_ip" {
  display_name = "Not allowed resource types"
  # or use a specific built-in name / id; this is just an example
}

resource "azurerm_policy_assignment" "deny_public_ip_assignment" {
  name                 = "deny-public-ip-assignment"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id

  description = "Assignment to deny public exposures in this RG"
}
