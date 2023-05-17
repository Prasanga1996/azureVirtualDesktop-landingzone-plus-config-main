data "azurerm_subscription" "primary" {
}

resource "azurerm_lighthouse_assignment" "example" {
  name = guid(mspName)
  scope = data.azurerm_subscription.primary.id
  lighthouse_definition_id = azurerm_lighthouse_definition.example.id
}