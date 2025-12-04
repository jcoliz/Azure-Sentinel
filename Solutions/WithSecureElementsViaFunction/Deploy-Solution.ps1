param(
    [Parameter(Mandatory=$true)]
    [string]
    $ISV,
    [Parameter(Mandatory=$true)]
    [string]
    $Sequence,
    [Parameter(Mandatory=$true)]
    [string]
    $Location
)
$ErrorActionPreference = "Stop"

$Suffix = "$env:USERNAME-$ISV-$Sequence"
$ResourceGroup = "sentinel-rg-$Suffix"

Write-Output "Checking Azure Subscription"
$account = az account show | ConvertFrom-Json

Write-Output "OK TN=$($account.homeTenantId) SU=$($account.id) $($account.name)"
Write-Output ""

Write-Output "Deploying solution to Workspace $workspaceName"
az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file .\Package\mainTemplate.json --parameter workspace-location=$Location --parameter workspace=$workspaceName

Write-Output "OK"
Write-Output ""
