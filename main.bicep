//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts
var location = resourceGroup().location
param ipaddress string
param vmsize string
param vmuser string
param sshPublicKey string
param keyvaultName string
param UserObjectID string
var vNetIpPrefix  = '192.168.0.0/24'
var defaultSubnetIpPrefix = '192.168.0.0/27'
var bastionSubnetIpPrefix = '192.168.0.32/27'

//Storage account for deployment scripts
module storage 'storage-account.bicep' = {
  name: 'deploymentScriptStorage'
  params: {
    location: location
    ipaddress: ipaddress
  }
}

module vnet './virtual_network.bicep' = {
  name: 'vnet'
  params:{
    virtualNetworkName: 'vnet01'
    vNetIpPrefix: vNetIpPrefix
    defaultSubnetIpPrefix: defaultSubnetIpPrefix
    location: location
    bastionSubnetIpPrefix: bastionSubnetIpPrefix
  }
}

module vm './virtual_machine.bicep' = {
  name: 'vm'
  params:{
    name: 'ubuntu20'
    location: location
    vmSize: vmsize
    subnetId: vnet.outputs.subnetId
    offer: '0001-com-ubuntu-server-focal'
    publisher: 'canonical'
    sku: '20_04-lts'
    version: 'latest'
    adminUsername: vmuser
    ssh_public_key: sshPublicKey
    storageAccountType: 'StandardSSD_LRS'
  }
  dependsOn:[
    [
      vnet
    ]
  ]
}

module bastion 'bastionhost.bicep' = {
  name: 'bastion'
  params:{
    location: location
    bastionHostName: 'bastionhost'
    virtualNetworkName: vnet.outputs.vnetname
    bastionSubnetIpPrefix: bastionSubnetIpPrefix
    ipaddress: ipaddress
  }
  dependsOn:[
    [
      vnet
    ]
  ]
}

module keyvault 'keyvalut.bicep' = {
  name: 'keyvault'
  params:{
    ipaddress: ipaddress
    keyvalutName: keyvaultName
    location: location
    tenantId: subscription().tenantId
    objectId: UserObjectID
  }
  dependsOn:[
    vnet
  ]
}

