param keyvalutName string
param location string
param tenantId string
param objectId string
param ipaddress string

resource keyvault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyvalutName
  location: location
  properties: {
    sku: {
      family: 'A'
      name:'standard'
    }
    tenantId: tenantId
    networkAcls:{
      bypass:'AzureServices'
      defaultAction:'Deny'
      ipRules:[
        {
          value: ipaddress
        }
      ]
    }
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions:{
          certificates:[
            'backup'
            'create'
            'delete'
            'deleteissuers'
            'get'
            'getissuers'
            'import'
            'list'
            'listissuers'
            'managecontacts'
            'manageissuers'
            'purge'
            'recover'
            'restore'
            'setissuers'
            'update'              
          ]
          keys:[
            'backup'
            'create'
            'decrypt'
            'delete'
            'encrypt'
            'get'
            'import'
            'list'
            'purge'
            'recover'
            'restore'
            'sign'
            'unwrapKey'
            'update'
            'verify'
            'wrapKey'              
          ]
          secrets:[
            'backup'
            'delete'
            'get'
            'list'
            'purge'
            'recover'
            'restore'
            'set'
          ]
          storage:[
            'backup'
            'delete'
            'deletesas'
            'get'
            'getsas'
            'list'
            'listsas'
            'purge'
            'recover'
            'regeneratekey'
            'restore'
            'set'
            'setsas'
            'update'
          ]
        }
      }
    ]
  }
}
