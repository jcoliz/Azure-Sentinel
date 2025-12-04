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

Write-Output "Creating Resource Group $ResourceGroup in $Location"
$rg = az group create --name $ResourceGroup --location $Location | ConvertFrom-Json

Write-Output "OK $($rg.id)"
Write-Output ""

Write-Output "Creating Sentinel Workspace in $ResourceGroup"
$sentinel = az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file C:\Source\jcoliz\AzDeploy.Bicep\SecurityInsights\sentinel-complete.bicep --parameter suffix=$Suffix | ConvertFrom-Json

$workspaceName = $sentinel.properties.outputs.logAnalyticsName.value
$workspaceId = $sentinel.properties.outputs.logAnalyticsWorkspaceId.value

Write-Output "OK $workspaceName ID: $workspaceId"
Write-Output ""

Write-Output "Deploying solution to Workspace $workspaceName"
az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file .\Package\mainTemplate.json --parameter workspace-location=$Location --parameter workspace=$workspaceName

Write-Output "OK"
Write-Output ""

Write-Output "TN $($account.homeTenantId)"
Write-Output "SU $($account.id) $($account.name)"
Write-Output "RG: $ResourceGroup in $Location"
Write-Output "LA: $workspaceName ID: $workspaceId"
