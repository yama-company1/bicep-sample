param virtualNetworkName string
param vNetIpPrefix string
param defaultSubnetIpPrefix string
param location string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetIpPrefix
      ]
    }
  }
}

resource subNet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetwork.name}/default'
  properties: {
    addressPrefix: defaultSubnetIpPrefix
  }
}

output vnetname string = virtualNetwork.name
output subnetid string = subNet.id
