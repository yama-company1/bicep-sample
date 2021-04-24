param name string
param location string
param vmSize string
param subnetId string
param offer string
param publisher string
param sku string
param version string
param adminUsername string
param ssh_public_key string
param storageAccountType string


resource vmnic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'vmnic'
  location: location
  properties:{
    ipConfigurations:[
      {
        name: 'ipconfig1'
        properties:{
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion:'IPv4'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile:{
      vmSize: vmSize
    }
    osProfile:{
      adminUsername: adminUsername
      linuxConfiguration:{
        ssh:{
          publicKeys : [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: ssh_public_key
            }
          ]
        }
        disablePasswordAuthentication:true
      }
      computerName: 'samplelinux'
    }
    networkProfile:{
      networkInterfaces:[
        {
          id: vmnic.id
        }
      ]
    }
    storageProfile:{
      imageReference:{
        offer: offer
        publisher: publisher
        version: version
        sku: sku
      }
      osDisk:{
        createOption:'FromImage'
        managedDisk:{
          storageAccountType: storageAccountType
        }
      }
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled: true
      }
    }
  }
}
