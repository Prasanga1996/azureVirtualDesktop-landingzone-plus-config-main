$ErrorActionPreference = "Stop"
#Import-Module "$PsScriptRoot\.Modules\Az.Accounts", "$PsScriptRoot\.Modules\Az.Resources"

Write-Host "Login with your Office 365 account if the client is in Lighthouse, otherwise use the client's global administrator login."

# Log into the azure portal using devile authentication
#Connect-AzAccount -UseDeviceAuthentication
az login --scope https://graph.microsoft.com/.default

# Select the working subscription from the list if you have multiple subscription
Get-Azsubscription | Out-GridView -PassThru | set-AzContext

# Write the Terraform variable file content to a file
#$terraformVariables | Out-File -FilePath 'variables.tf'

# Move to the Terraform working directory (replace with your actual Terraform project directory)
# Define the path to the first Terraform module directory
$module3Path = "D:\AB Technologies\AB-Total\azureVirtualDesktop\modules\lighthouse"

# Move to the first Terraform module directory
Set-Location -Path $module3Path
<#
 Check if the .terraform directory exists
if (-not (Test-Path -Path ".terraform")) {
     Initialize Terraform if the .terraform directory doesn't exist
    terraform init
}
#>

# Initialize Terraform
terraform init
# Run terraform plan
$planOutput = & terraform plan -out=tfplan

# Check if there are any error messages in the plan output
if ($planOutput -notlike "*Error*") {
# Apply the changes 
  & terraform apply tfplan
} 
else {
  Write-Host "Errors found in the plan. Apply canceled."
}