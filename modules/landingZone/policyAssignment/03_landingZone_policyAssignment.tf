
#Some policy assignments are hardcoded in the Azure Bicep Code.
#You can add those assignments.
data "azurerm_subscription" "primary" {

}

#Policy definition file
resource "azurerm_policy_definition" "azureBackupOnProdCustomPolicy" {
  name        = "azureBackupOnProd"
  display_name   = "ABT - Azure Backup should be enabled for Virtual Machines"
  description = "Ensure protection of your Azure Virtual Machines by enabling Azure Backup. Azure Backup is a secure and cost effective data protection solution for Azure."
  policy_type = "Custom"
  mode = "Indexed"
  metadata = <<METADATA
      {
      "version": "1.0.0",
      "category": "Backup"
      }

METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
          },
          {
            "field": "tags['environment']",
            "equals": "Production"
          }
        ]
      },
      "then": {
        "effect": "AuditIfNotExists",
        "details": {
          "type": "Microsoft.RecoveryServices/backupprotecteditems"
          }
        }
      }
POLICY_RULE
}

# Azure Backup custom policy assignment
resource "azurerm_subscription_policy_assignment" "applyAzureBackupOnProdCustomPolicy" {
  name                 = "applyAzureBackupOnProd"
  policy_definition_id = azurerm_policy_definition.azureBackupOnProdCustomPolicy.id
  subscription_id      = data.azurerm_subscription.primary.id
}

# Allowed locations policy assignment
#This allowed_locations policy assignment resource having hardcoded policy definition id. 


