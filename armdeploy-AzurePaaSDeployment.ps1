Install-Module Az -Force
Import-Module Az 

Login-AzAccount
Get-AzureRmContext

Select-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise"

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope Process

#### Api-version

((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Where-Object ResourceTypeName -eq sites).ApiVersions
(Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Format-Table
$Provider=Get-AzureRmResourceProvider | Format-Table 
$Provider.ResourceTypes
#####
$resourceGroupName = "LandRegistryPricePaid" 
New-AzureRmResourceGroup -Name $resourceGroupName  -Location "West Europe" -Force 

# Just validates the json file from github. Then removes the resource
Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateUri 'https://raw.githubusercontent.com/tzishi1991/AzurePaaSDeployment/master/azuredeploy.json' `
-TemplateParameterUri 'https://raw.githubusercontent.com/tzishi1991/AzurePaaSDeployment/master/azuredeploy.parameters.json'

Remove-AzureRmResourceGroup $resourceGroupName -Force
New-AzureRmResourceGroup -Name $resourceGroupName  -Location "West Europe" -Force 

#$resourceGroupDeployment = New-AzResourceGroupDeployment -Name $resourceGroupName'Deployment' -ResourceGroupName $resourceGroupName `
#-TemplateFile .\\arm-functionapp-sql-main.json -TemplateParameterFile .\armdeploy-functionappsql.paramaters.json -DeploymentDebugLogLevel All -Mode Complete -Force

# Deploy from Github repo
$resourceGroupDeployment = New-AzureRmResourceGroupDeployment -Name $resourceGroupName'Deployment' -ResourceGroupName $resourceGroupName `
-TemplateUri 'https://raw.githubusercontent.com/tzishi1991/AzurePaaSDeployment/master/azuredeploy.json' `
-TemplateParameterUri 'https://raw.githubusercontent.com/tzishi1991/AzurePaaSDeployment/master/azuredeploy.parameters.json' `
-DeploymentDebugLogLevel All -Mode Complete -Force

