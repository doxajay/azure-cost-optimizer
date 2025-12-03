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

# Resource group to be governed by the policy
resource "azurerm_resource_group" "rg" {
  name     = "rg-policy-demo"
  location = "canadacentral"
}

# Built-in policy definition: "Not allowed resource types"
# This policy requires the parameter: listOfResourceTypesNotAllowed
data "azurerm_policy_definition" "deny_public_ip" {
  display_name = "Not allowed resource types"
}

resource "azurerm_resource_group_policy_assignment" "deny_public_ip_assignment" {
  name                 = "deny-public-ip-assignment"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id

  display_name = "Deny public IP addresses in this resource group"

  # This text helps people understand *why* they’re blocked
  description = "This resource group is protected by policy. " +
    "Creation of Microsoft.Network/publicIPAddresses is blocked. " +
    "If you see a 'Denied by policy' error, deploy without a public IP " +
    "or use a resource group that allows public IPs."

  # Pass required parameter so the built-in policy knows what to block
  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = [
        "Microsoft.Network/publicIPAddresses"
      ]
    }
  })
}
