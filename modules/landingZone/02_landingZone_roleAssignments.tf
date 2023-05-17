/*
data "azurerm_subscription" "primary" {

}

resource "azurerm_role_assignment" "owner_role" {
  #Name to be a valid UUID.
  #In Bicep, Name given as subscriptionOwner
  name                = uuid()
  scope               = data.azurerm_subscription.primary.id 
  role_definition_name  = "Owner"
  # ID of the Principal (User, Group or Service Principal) to assign the Role Definition to.
  # Use Principal type as User
  principal_id        = var.principalId 
}
*/


