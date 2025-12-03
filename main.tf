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

# -----------------------------------------
# Resource Group (Scope for policy assignment)
# -----------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-policy-demo"
  location = "canadacentral"
}

# ---------------------------------------------------
# Built-in Policy Definition: Not allowed resource types
# This policy requires a parameter: listOfResourceTypesNotAllowed
# ---------------------------------------------------
data "azurerm_policy_definition" "deny_public_ip" {
  name = "6c112d4e-5bc7-47ae-a041-ea2d9dccd749"   # built-in definition ID
}

# ---------------------------------------------------
# Policy Assignment WITH required parameter + description
# ---------------------------------------------------
resource "azurerm_resource_group_policy_assignment" "deny_public_ip_assignment" {
  name               = "deny-public-ip-assignment"
  resource_group_id  = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.deny_public_ip.id

  # Required parameter
  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = ["Microsoft.Network/publicIPAddresses"]
    }
  })

  # Non-compliance message in a safe heredoc block
  description = <<EOF
This resource group is protected by a policy that prevents creation of 
Microsoft.Network/publicIPAddresses. Any attempt to deploy resources 
with public IPs will be denied to ensure secure-by-default standards.
EOF
}
