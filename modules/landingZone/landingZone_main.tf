locals {
   variable_values = {
   for row in csvdecode(file("D:/Projects/2023/AB Technologies/Terraform Scripts/variable.csv")) : row.variable_name => row.variable_value
  }
}

#Module for coreNetwork
module "coreNetwork" {
    source = "./coreNetwork"
    #This subscriptionlocation refering to powershell script variable file "variable.csv"
    subscriptionLocation = local.variable_values["subscriptionLocation"]
    tagWorkload = var.tagWorkload
    tagManagedBy = var.tagManagedBy
    tagEnvironment = var.tagEnvironment
    tagImpact = var.tagImpact
    #This clientshortHand refering to powershell script variable file "variable.csv"
    clientShortHand = local.variable_values["clientShortHand"]
}

/*
module "policy_assignments" {
    source = "./policyAssignment"
}
*/

