param(
    [Parameter(Mandatory=$true)]
    [string]
    $Sequence,
    [Parameter(Mandatory=$true)]
    [string]
    $Location
)
$ErrorActionPreference = "Stop"

$Suffix = "$env:USERNAME-fortinet-$Sequence"
$ResourceGroup = "sentinel-rg-$Suffix"

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

Write-Output "Deploying solution to Workspace $Workspace"
az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file .\Package\mainTemplate.json --parameter workspace-location=$Location --parameter workspace=$workspaceName
#--parameter ukey=$Sequence <- Not used here

Write-Output "OK"
Write-Output ""

Write-Output "RG: $ResourceGroup in $Location"
Write-Output "LA: $workspaceName ID: $workspaceId"
