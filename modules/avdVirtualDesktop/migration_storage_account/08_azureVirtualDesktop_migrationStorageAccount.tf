# Resource Group for Migration Storage Account
resource "azurerm_resource_group" "migration_storage_account" {
  name     = "${var.clientShortHand}-migrationstorage"
  #Check this location
  location = var.subscriptionLocation
}

resource "azurerm_storage_account" "clientmigrationstorage" {
  name                     = "abtmigrationstorage358"
  location                 = azurerm_resource_group.migration_storage_account.location
  resource_group_name      = azurerm_resource_group.migration_storage_account.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  access_tier             = "Hot"
  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_storage_share" "clientmigrationfileshare" {
  #Check name
  name                 = "migrationstorage"
  storage_account_name = azurerm_storage_account.clientmigrationstorage.name
  access_tier = "TransactionOptimized"
  quota                = 50
  depends_on = [azurerm_storage_account.clientmigrationstorage]
}
