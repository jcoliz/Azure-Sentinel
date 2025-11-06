param(
    [Parameter(Mandatory=$true)]
    [string]
    $Sequence,
    [Parameter(Mandatory=$true)]
    [string]
    $Location
)

$Suffix = "$env:USERNAME-$Sequence"
$Workspace = "sentinel-$Suffix"
$ResourceGroup = "sentinel-rg-$Suffix"

Write-Output "Creating Resource Group $ResourceGroup in $Location"
az group create --name $ResourceGroup --location $Location

Write-Output "Creating Sentinel Workspace $Workspace in $ResourceGroup"
az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file C:\Source\jcoliz\AzDeploy.Bicep\SecurityInsights\sentinel-complete.bicep --parameter suffix=$Suffix

Write-Output "OK"
Write-Output ""

Write-Output "Deploying solution to Workspace $Workspace"
$r2 = az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file .\Package\mainTemplate.json --parameter workspace-location=$Location --parameter workspace=$Workspace --parameter ukey=$Sequence | ConvertFrom-Json

Write-Output "OK"
Write-Output ""

Write-Output "RG: $ResourceGroup in $Location"
Write-Output "LA: $Workspace"
