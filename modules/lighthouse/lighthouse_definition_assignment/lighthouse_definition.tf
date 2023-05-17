resource "azurerm_lighthouse_definition" "allianceBusinessTechnologiesRegistrationDefinition" {
  name = guid(var.mspName)
  description = var.mspName
  managed_by_tenant_id = var.managedByTenantId
  scope = "/subscriptions/${var.subscription_id}"

  authorization {
    principal_id = "ad86b7fc-f5b2-4f2f-98f3-870702744dcd"
    principal_id_display_name = "ABT - Azure Subscription Contributors"
    role_definition_id = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  }

  authorization {
    principal_id = "ce036386-78fd-48ef-bb7f-bfbde0f1fc75"
    principal_id_display_name = "ABT - Azure Virtual Machine Contributors"
    role_definition_id = "9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
  }

  authorization {
    principal_id = "f7df5994-9078-45db-a6db-80632e78045f"
    principal_id_display_name = "ABT - Azure Readers"
    role_definition_id = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
  }
}

