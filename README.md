# Bicep sample (Ubunt VM ＋ Bastion)

## Preparation
1. Install az cli  
https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli
1. bicep install
https://github.com/Azure/bicep/blob/main/docs/installing.md#windows-installer
1. Edit parameter File
- azuredeploy.parameters.dev.json</br>
xxx.xxx.xxx.xxx -> Your IP Address.
```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "ipaddress": {
      "value": "xxx.xxx.xxx.xxx"
    }
  }
}
```

## Usage
### STEP 1
1. Set Parameter

```
$tenantid = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$subscription = "dc5d3c89-36dd-4a3c-b09b-e6ee41f6d5b5"
$bicepFile = "main.bicep"
$parameterFile = "azuredeploy.parameters.dev.json"
$resourceGroupName = "bicepsample2"
$location = "japanwest"
```

2. Go to STEP2 (Azure CLI or PowerShell)


### STEP 2 (Azure CLI)
1. Azure Login
```
az login -t ${tenantid}	--verbose
```
2. Set Subscription
```
az account set --subscription ${subscription} --verbose
```
3. Create Resource Group  
```
az group create --name bicepsample --location ${location} --verbose
```
4. Deployment Create  
```
az deployment group create --resource-group bicepsample --template-file main.bicep --parameters ${parameterFile} --verbose
```

### STEP 2 (PowerShell)
1. Azure Login
```
Connect-AzAccount -Tenant ${tenantid} -Subscription ${subscription}
```
2. Create Resource Group  
```
New-AzResourceGroup -Name ${resourceGroupName} -Location ${location} -Verbose
```
3. Deployment Create  
```
New-AzResourceGroupDeployment `
  -Name devenvironment `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile $bicepFile `
  -TemplateParameterFile $parameterFile `
  -Verbose
```
