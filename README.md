# Bicep sample

## Preparation
1. Install az cli  
https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli

## Usage
1. Create Resource Group  
```
az group create --name bicepsample --location "japanwest"
```
1. Deployment Create  
```
az deployment group create --resource-group bicepsample --template-file main.bicep --parameters rgName=bicepsample location=japanwest
```
