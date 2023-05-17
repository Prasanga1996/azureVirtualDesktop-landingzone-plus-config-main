locals {
   variable_values = {
   for row in csvdecode(file("D:/Projects/2023/AB Technologies/Terraform Scripts/variable.csv")) : row.variable_name => row.variable_value
  }
}

#Module for BackendServers
module "backendServers" {
    source = "./backendServers"
    adminPassword = local.variable_values["adminPassword"]
    subscriptionLocation = local.variable_values["subscriptionLocation"]
    tagWorkload = var.tagWorkload
    tagManagedBy = var.tagManagedBy
    tagEnvironment = var.tagEnvironment
    tagImpact = var.tagImpact
    clientShortHand = local.variable_values["clientShortHand"]
}

#Module for azure Virtual Desktop
module "azureVirtualDesktop" {
    source = "./azure_virtual_desktop"
    subscriptionLocation = local.variable_values["subscriptionLocation"]
    tagWorkload = var.tagWorkload
    tagManagedBy = var.tagManagedBy
    tagEnvironment = var.tagEnvironment
    tagImpact = var.tagImpact
    clientShortHand = local.variable_values["clientShortHand"]
}

# Module for Automation Account
module "automation_account" {
    source  = "./automation_account"
    subscriptionLocation = local.variable_values["subscriptionLocation"]
    tagWorkload = var.tagWorkload
    tagManagedBy = var.tagManagedBy
    tagEnvironment = var.tagEnvironment
    tagImpact = var.tagImpact
    clientShortHand = local.variable_values["clientShortHand"]
    automationAccountSku = local.variable_values["automationAccountSku"]
}

# Module for Backup
module "backup" {
    source  = "./backup"
    subscriptionLocation = local.variable_values["subscriptionLocation"]
    tagWorkload = var.tagWorkload
    tagManagedBy = var.tagManagedBy
    tagEnvironment = var.tagEnvironment
    tagImpact = var.tagImpact
    clientShortHand = local.variable_values["clientShortHand"]
}


# Module for Migration Storage Account
module "migration_storage_account" {
    source  = "./migration_storage_account"
    subscriptionLocation = local.variable_values["subscriptionLocation"]
    tagWorkload = var.tagWorkload
    tagManagedBy = var.tagManagedBy
    tagEnvironment = var.tagEnvironment
    tagImpact = var.tagImpact
    clientShortHand = local.variable_values["clientShortHand"]
}
