terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Enable Azure Policy for Cost Optimization
resource "azurerm_policy_assignment" "deny_public_ip" {
  name                 = "policy-deny-public-ip"
  scope                = data.azurerm_subscription.primary.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2d9cae02-6151-4a68-83c7-3a7db3a0e0a9"
}

data "azurerm_subscription" "primary" {}
