resource "azurerm_resource_group" "automation_account" {
  name     = "${var.clientShortHand}-automation"
  #This SubscriptionLocation is refering in all modules.
  location = var.subscriptionLocation
}

resource "azurerm_automation_account" "automationAccount" {
  name                = "${var.clientShortHand}-avdAutomation"
  location            = azurerm_resource_group.automation_account.location
  resource_group_name = azurerm_resource_group.automation_account.name
  sku_name            = var.automationAccountSku
  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

