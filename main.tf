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

# Resource group scope for policy assignment
resource "azurerm_resource_group" "rg" {
  name     = "rg-policy-demo"
  location = "canadacentral"
}

# Built-in Azure Policy: "Not allowed resource types"
# Block creation of Public IPs explicitly
data "azurerm_policy_definition" "deny_public_ip" {
  display_name = "Not allowed resource types"
}

resource "azurerm_resource_group_policy_assignment" "deny_public_ip_assignment" {
  name                 = "deny-public-ip-assignment"
  scope                = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id

  description = "🚫 Public IPs are not allowed in this resource group. Please use Private Endpoints or Internal Load Balancers for secure access."

  # Required parameter for this built-in policy
  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = [
        "Microsoft.Network/publicIPAddresses"
      ]
    }
  })
}
