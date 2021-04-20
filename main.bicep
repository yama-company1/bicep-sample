//scope
targetScope = 'resourceGroup'
//Storage account for deployment scripts
param rgName string
param location string


//Storage account for deployment scripts
module storage './storage-account.bicep' = {
  name: 'deploymentScriptStorage'
  scope: resourceGroup(rgName)
  params: {
    location: location
  }
}

module vnet './virtual_network.bicep' = {
  name: 'vnet'
  scope: resourceGroup(rgName)
  params:{
    virtualNetworkName: 'vnet01'
    vNetIpPrefix: '10.1.0.0/24'
    defaultSubnetIpPrefix: '10.1.0.0/27'
    location: location
  }
}


module vm './virtual_machine.bicep' = {
  name: 'vm'
  scope: resourceGroup(rgName)
  params:{
    name: 'ubuntu20'
    location: location
    vmSize: 'Standard_D4s_v3'
    subnetId: vnet.outputs.subnetid
    offer: '0001-com-ubuntu-server-focal'
    publisher: 'canonical'
    sku: '20_04-lts'
    version: 'latest'
    adminUsername: 'adminuser'
    ssh_public_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwTXfsS4+FRigKOYxWt9NYIQ2nSEA+dRu40d2+gkYEaZEuXpTL1VO+PNHzibC9v6zKwBD2bTyvCGb88/ybB6uKicUKlZhNKZs+tSvyrhgF+15Xh/3K1gS+ZAGszt3xUBHPynM4HcOU/anx32zO+lHCRUDPkbSeRlXzUsUJ0tC0aoye9kQsh96jF9Z2OrTPL42eLmLtK+uVNHwQvrhmuYrRAdlTM1we6Brf0AqeX8t1qNTMF9oURNSAFL5S21V+gYQlXIflUSEoFpHEWy/I9Drt6OREW6alxbuTHTw8LFk0E4yIWuOUXgYsnJt84W0EElyip7LJyzEtdg06NSeVhxSB'
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
  scope: resourceGroup(rgName)
  params:{
    location: location
    bastionHostName: 'bastionhost'
    virtualNetworkName: vnet.outputs.vnetname
    bastionSubnetIpPrefix: '10.1.0.32/27'
  }
  dependsOn:[
    [
      vnet
    ]
  ]
}

