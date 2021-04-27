# Bicep sample (Ubunt VM ＋ Bastion)

## Preparation
1. Install az cli  
https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli
1. bicep install
https://github.com/Azure/bicep/blob/main/docs/installing.md#windows-installer
1. Edit parameter File
- azuredeploy.parameters.dev.json</br>
  - require</br>
  xxx.xxx.xxx.xxx -> Your IP Address.</br>
  xxx(vmpassword)(At least 12 characters (uppercase, lowercase, and numbers)) </br>
  xxxx (sshPublicKey) </br>
  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx(UserObjectID) </br>
  xxxxx (keyvaultName)
  - option</br>
  vmuser -> Your choice Virtual Machine User ID.</br>
  Standard_D4s_v3 -> Your choice Virtual Machine Size. </br>
```
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "ipaddress": {
      "value": "xxx.xxx.xxx.xxx"
    },
    "vmsize": {
      "value": "Standard_D4s_v3"
    },
    "vmuser": {
      "value": "adminuser"
    },
    "UserObjectID": {
      "value": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    },
    "sshPublicKey": {
      "value": "xxxx"
    },
    "keyvaultName": {
      "value": "xxxxx"
    }
  }
}
```
## option
1. Create SSH Private Key
```
ssh-keygen `
    -m PEM `
    -t rsa `
    -b 4096 `
    -C "foo@sample.jpn.com" `
    -f .\private_key `
    -N passphrase
```
1. View Public Key
```
ssh-keygen `
    -y -f .\private_key
```

## Usage
### STEP 1
1. Execute PowerShell Prompt
1. Set Parameter(x)

```
set-variable -name TENANT_ID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -option constant
set-variable -name SUBSCRIPTOIN_GUID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -option constant
set-variable -name BICEP_FILE "main.bicep" -option constant
set-variable -name PARAMETER_FILE "azuredeploy.parameters.dev.json" -option constant

$resourceGroupName = "xxxxx"
$location = "xxxxx"
```

2. Go to STEP2 (Azure CLI or PowerShell)


### STEP 2 (Azure CLI)
1. Azure Login
```
az login -t ${TENANT_ID} --verbose
```
2. Set Subscription
```
az account set --subscription ${SUBSCRIPTOIN_GUID} --verbose
```
3. Create Resource Group  
```
az group create --name ${resourceGroupName} --location ${location} --verbose
```
4. Deployment Create  
```
az deployment group create --resource-group ${resourceGroupName} --template-file ${BICEP_FILE} --parameters ${PARAMETER_FILE} --verbose
```

### STEP 2 (PowerShell)
1. Azure Login
```
Connect-AzAccount -Tenant ${TENANT_ID} -Subscription ${SUBSCRIPTOIN_GUID}
```
2. Create Resource Group  
```
New-AzResourceGroup -Name ${resourceGroupName} -Location ${location} -Verbose
```
3. Create Deployment
```
New-AzResourceGroupDeployment `
  -Name devenvironment `
  -ResourceGroupName ${resourceGroupName} `
  -TemplateFile ${BICEP_FILE} `
  -TemplateParameterFile ${PARAMETER_FILE} `
  -Verbose
```
