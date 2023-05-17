resource "azurerm_resource_group" "azureVirtualDesktopResourceGroup" {
name = "${var.clientShortHand}-avd"
#This location refering to subscription location.
location = var.subscriptionLocation
}

resource "azurerm_storage_account" "fslogixstg" {
  #check the name
  name                     = "abtfslogixstg969"
  location                 = azurerm_resource_group.azureVirtualDesktopResourceGroup.location
  resource_group_name      = azurerm_resource_group.azureVirtualDesktopResourceGroup.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind              = "StorageV2"
  #large_file_shares_state  = "Disabled"
  large_file_share_enabled = true
  network_rules {

    default_action = "Allow"
    bypass         = ["AzureServices"]
    ip_rules       = ["103.211.20.138"]
  }

  enable_https_traffic_only = true
  
 /*account_encryption_source {
    services {
      file {
        key_type = "Account"
        enabled  = true
      }
      blob {
        key_type = "Account"
        enabled  = true
      }
    }
    key_source = "Microsoft.Storage"
  }
  */
  access_tier = "Hot"

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_storage_share" "fslogixShare" {
  #Check the name
  name                    = "fslogixstg"
  #/default/fslogix
  storage_account_name    = azurerm_storage_account.fslogixstg.name
  quota                   = 5120
  enabled_protocol        = "SMB"
  access_tier             = "TransactionOptimized"
  depends_on              = [azurerm_storage_account.fslogixstg]
}

data "azurerm_subnet" "existing_subnet" {
  name                 = "backend-subnet"
  virtual_network_name = "core-vnet"
  resource_group_name  = "${var.clientShortHand}-core"
}

#Check the whole block
resource "azurerm_private_endpoint" "fslogixpe" {
  name                = "${var.clientShortHand}fslogixpe"
  location                 = azurerm_resource_group.azureVirtualDesktopResourceGroup.location
  resource_group_name      = azurerm_resource_group.azureVirtualDesktopResourceGroup.name
  subnet_id = data.azurerm_subnet.existing_subnet.id

  private_service_connection {
    name                           = "${var.clientShortHand}fslogixstg_8cbb52c9-c400-4e50-97c7-617aa4a7400f"
    private_connection_resource_id = azurerm_storage_account.fslogixstg.id
    subresource_names                      = ["file"]
    is_manual_connection           = false
  }
  
  depends_on          = [azurerm_storage_account.fslogixstg]
  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_virtual_desktop_host_pool" "hp01" {
  name                = "${var.clientShortHand}-hp-01"
  location            = var.avdLocation
  resource_group_name = azurerm_resource_group.azureVirtualDesktopResourceGroup.name
  preferred_app_group_type = "Desktop"
  friendly_name       = "Host Pool 1"
  type      = "Pooled"
  load_balancer_type  = "DepthFirst"

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_virtual_desktop_application_group" "dag01" {
  name                = "${var.clientShortHand}-dag-01"
  location            = var.avdLocation
  resource_group_name = azurerm_resource_group.azureVirtualDesktopResourceGroup.name
   type          = "Desktop"
  friendly_name       = "Desktop Application Group 1"
    host_pool_id        = azurerm_virtual_desktop_host_pool.hp01.id

  depends_on = [
    azurerm_virtual_desktop_host_pool.hp01
  ]

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_virtual_desktop_workspace" "avdws01" {
  name                = "${var.clientShortHand}-avd-ws-01"
  location            = var.avdLocation
  resource_group_name = azurerm_resource_group.azureVirtualDesktopResourceGroup.name
  friendly_name       = "AVD Workspace 1"

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}
