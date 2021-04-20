param location string
param bastionHostName string
param virtualNetworkName string
param bastionSubnetIpPrefix string

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${bastionHostName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource subNet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworkName}/AzureBastionSubnet'
  properties: {
    addressPrefix: bastionSubnetIpPrefix
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: subNet.id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}
