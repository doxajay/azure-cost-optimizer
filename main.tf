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

# 1) Resource group to have a simple scope for the policy
resource "azurerm_resource_group" "rg" {
  name     = "rg-policy-demo"
  location = "canadacentral"
}

# 2) Built-in policy definition: "Not allowed resource types"
#    This is the policy that expects the parameter: listOfResourceTypesNotAllowed
data "azurerm_policy_definition" "deny_public_ip" {
  display_name = "Not allowed resource types"
}

# 3) Assign the policy at the resource group level
resource "azurerm_resource_group_policy_assignment" "deny_public_ip_assignment" {
  name              = "deny-public-ip-assignment"
  resource_group_id = azurerm_resource_group.rg.id

  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id
  description          = "Deny creation of public IP addresses in this resource group"

  # Required parameter for this policy definition
  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = [
        # Block public IP address resources in this RG
        "Microsoft.Network/publicIPAddresses"
      ]
    }
  })
}
