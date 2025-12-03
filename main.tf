terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-policy-demo"
  location = "canadacentral"
}

# Built-in Azure policy to deny Public IP addresses
data "azurerm_policy_definition" "deny_public_ip" {
  # This is the Azure built-in policy with parameters
  name = "6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
}

# Assign Policy to RG
resource "azurerm_resource_group_policy_assignment" "deny_public_ip_assignment" {
  name                 = "deny-public-ip-assignment"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id

  description = "This operation is not allowed due to preset company security policy. Contact your Azure Administrator if you require a public IP."

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = [
        "Microsoft.Network/publicIPAddresses"
      ]
    }
  })
}
