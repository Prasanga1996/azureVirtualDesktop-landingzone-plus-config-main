# Resource Group for Backup
resource "azurerm_resource_group" "backup" {
  name     = "${var.clientShortHand}-backup"
  #Check this location.
  location = var.subscriptionLocation
}

resource "azurerm_recovery_services_vault" "rsv" {
  name                = "${var.clientShortHand}-rsv"
  location            = azurerm_resource_group.backup.location
  resource_group_name = azurerm_resource_group.backup.name
  #sku_name = "RS0"
  sku            = "Standard"

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

#Check this block
resource "azurerm_backup_policy_vm" "rsvPolicies" {
  #Check the name
  name                = "${var.clientShortHand}-rsv"
  #/ABTBackupPolicy
  recovery_vault_name = azurerm_recovery_services_vault.rsv.name
  resource_group_name = azurerm_resource_group.backup.name
  timezone = "AUS Eastern Standard Time"
  instant_restore_retention_days = 2
  # protectedItemsCount = 0
  backup {
    frequency = "Daily"
    #Check the time
    time      = "16:30"

  }

  retention_daily {
    count = 30
  }

  retention_monthly {
    count    = 3
    weekdays = ["Monday"]
    weeks    = ["First"]
  }
  
  depends_on = [
    azurerm_recovery_services_vault.rsv
  ]

  #Tags are not allowed/
  /*
  tags = {
   "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }

  */
  
}
